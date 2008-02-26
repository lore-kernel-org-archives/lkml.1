Return-Path: <linux-kernel-owner+w=401wt.eu-S1762841AbYBZSmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762841AbYBZSmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYBZSmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:42:44 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:57407 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYBZSmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:42:43 -0500
Date: Tue, 26 Feb 2008 10:42:35 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080226184235.GA5914@localdomain>
References: <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com> <20080224122903.GC13637@one.firstfloor.org> <20080225190819.GE3143@localdomain> <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com> <20080226033945.GJ3143@localdomain> <20080226034625.GE21577@one.firstfloor.org> <20080226040541.GK3143@localdomain> <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 09:27:42PM -0800, Yinghai Lu wrote:
>On Mon, Feb 25, 2008 at 8:05 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
>> On Tue, Feb 26, 2008 at 04:46:25AM +0100, Andi Kleen wrote:
>>
>>  >
>>  >If you can't support that in your hardware you're supposed
>>  >to clear it.
>>
>>  Hmm! How would a hardware vendor do that? That doesn't seem to be clear in
>>  the BKDG. (Well, this is the problem with undocumented features :()
>>
>any good sign for APIC_clustered box? there is apicid between cpus
>even all cpu are quadcore and fully populated?

I would suggest checking the SLIT distances -- On AMD boxes, if you have three
different distances between nodes, then that system would be multiboard,
and there is no way TSCs can be synced.  On Intel boxes, if there are two
different distances between nodes, then this would be a multi board/multi
chassi box and TSCs won't be synced.  This is a more generic solution and
should work on Summit/Unisys boxes as well.  (I am ignoring Intel CSI for
now.  It might need the same treatment as AMD)

Comments?

Kiran
