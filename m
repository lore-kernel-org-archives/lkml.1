Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbXISQFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbXISQFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXISQFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:05:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbXISQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:05:01 -0400
Message-ID: <46F14896.8080603@zytor.com>
Date: Wed, 19 Sep 2007 09:04:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3 1/2] i386/x86_64 boot: setup data
References: <1190192306.12429.76.camel@caritas-dev.intel.com>
In-Reply-To: <1190192306.12429.76.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> Known Issues:
> 
> 1. Where is safe to place the linked list of setup_data?
> Because the length of the linked list of setup_data is variable, it
> can not be copied into BSS segment of kernel as that of "zero
> page". We must find a safe place for it, where it will not be
> overwritten by kernel during booting up. The i386 kernel will
> overwrite some pages after _end. The x86_64 kernel will overwrite some
> pages from 0x1000 on.
> 

The latter is definitely not safe, since the space below 640K is the
documented place to put the command line (and presumably where the
bootloader would put other auxilliary chunks.)

I'll try to do a full review of this later today.  Haven't had time yet
to look at this anything than but piecemeal.

	-hpa
