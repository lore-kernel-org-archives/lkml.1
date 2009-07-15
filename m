Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZGOBdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZGOBdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZGOBdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:33:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZGOBde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:33:34 -0400
Message-ID: <4A5D318C.5090508@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 09:31:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks"
 that shows only unique tgids
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>	 <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>	 <1247596470.13426.16088.camel@nimitz>	 <2f86c2480907141426r16f8ccf3o9770e25cc8d2e509@mail.gmail.com> <1247608169.13426.16602.camel@nimitz>
In-Reply-To: <1247608169.13426.16602.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2009-07-14 at 14:26 -0700, Benjamin Blum wrote:
>> This method looks to be a compromise between Andrew's proposed
>> generalized solution ( http://lkml.org/lkml/2009/7/2/518 ) and the
>> current quick-fix. The problem with it is that it'll require a layer
>> between whoever's using the array and managing the list structs (for
>> the case where we need to chain multiple blocks together), and if
>> we're going to put forth enough effort for that, we may as well go
>> ahead and write up a generalized kernel-wide library to fix this size
>> problem globally.
> 
> This "Andrew" guy seems to know what he's talking about. :)
> 
> We've also got a set of pgarrs (struct page arrays) in the
> checkpoint/restart code that would make use of something generic like
> this.  
> 

The dynamic-page-array thing sounds a right way to go. It's open-coded
in some other places, ring_buffer.c is one among.

