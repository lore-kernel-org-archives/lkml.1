Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZDVSk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZDVSk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZDVSkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:40:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZDVSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:40:09 -0400
Message-ID: <49EF6457.90505@zytor.com>
Date: Wed, 22 Apr 2009 11:39:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>,
       Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de>
In-Reply-To: <20090422180051.GD13280@skl-net.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> On 10:23, H. Peter Anvin wrote:
> 
>> We could use vmalloc() and generate the tables at initialization time.
>> However, having a separate module which exports the raid6 declaration
>> and uses the raid5 module as a subroutine library seems easier.
> 
> Really? Easier than keeping only two 256-byte arrays for exp() and
> log() and use these at runtime to populate the (dynamically allocated)
> 64K GF multiplication table? That seems to be really simple and would
> still shave off 64K of kernel memory for raid5-only users.
> 

Yes, I believe it would be easier than having dynamically allocated 
arrays.  Dynamically generated arrays using static memory allocations 
(bss) is one thing, but that would only reduce size of the module on 
disk, which I don't think anyone considers a problem.

	-hpa

