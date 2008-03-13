Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYCMIsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYCMIsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYCMIsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:48:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYCMIse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:48:34 -0400
Date: Thu, 13 Mar 2008 01:48:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
Message-Id: <20080313014808.f8d25c2a.akpm@linux-foundation.org>
In-Reply-To: <1205394417.3215.85.camel@ymzhang>
References: <1205394417.3215.85.camel@ymzhang>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 15:46:57 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> Comparing with 2.6.24, on my 16-core tigerton, hackbench process mode has about
> 40% regression with 2.6.25-rc1, and more than 20% regression with kernel
> 2.6.25-rc4, because rc4 includes the reverting patch of scheduler load balance.
> 
> Command to start it.
> #hackbench 100 process 2000
> I ran it for 3 times and sum the values.
> 
> I tried to investiagte it by bisect.
> Kernel up to tag 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806 has the 20% regression.
> Kernel up to tag 6e90aa972dda8ef86155eefcdbdc8d34165b9f39 hasn't regression.
> 
> Any bisect between above 2 tags cause kernel hang. I tried to checkout to a point between
> these 2 tags for many times manually and kernel always paniced.
> 
> All patches between the 2 tags are on kobject restructure. I guess such restructure
> creates more cache miss on the 16-core tigerton.
> 

That's pretty surprising - hackbench spends most of its time in userspace
and zeroing out anonymous pages.  It shouldn't be fiddling with kobjects
much at all.

Some kernel profiling might be needed here..
