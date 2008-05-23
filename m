Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbYEWUnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbYEWUnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbYEWUm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:42:56 -0400
Received: from gw.goop.org ([64.81.55.164]:48158 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758421AbYEWUmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:42:55 -0400
Message-ID: <48372C2F.1090704@goop.org>
Date: Fri, 23 May 2008 21:42:23 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte read-modify-write abstraction
References: <patchbomb.1211552448@localhost> <alpine.LFD.1.10.0805231133130.3081@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805231133130.3081@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 23 May 2008, Jeremy Fitzhardinge wrote:
>   
>> This series adds the pte_rmw_start() and pte_rmw_commit() operations,
>> which change this sequence to:
>>
>> 	ptent = pte_rmw_start(mm, addr, pte);
>> 	ptent = pte_modify(ptent, newprot);
>> 	/* ... */
>> 	pte_rmw_commit(mm, addr, pte, ptent);
>>     
>
> Can you please rename these.
>
> It's not a general "read-modify-write" operation on the PTE, and this 
> *only* works for changing protection details. In particular, you cannot 
> use pte_rmw_start/commit to change the actual page. So it's very much 
> about just protection bits.
>   

Well, you could use it to update the page and protection bits while 
preserving the AD bits, but I don't think that's very useful.

> It should probably also be called ptep_xyz(), since it takes a pte 
> pointer, not a pte.
>
> So maybe calling it "ptent = ptep_modify_prot_start(..)" ... 
> "ptep_modify_prot_commit(..)" or something.
>   

Yep, sounds fine to me.

    J

