Return-Path: <linux-kernel-owner+w=401wt.eu-S2992974AbXDYTSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992974AbXDYTSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992978AbXDYTSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:18:51 -0400
Received: from gw.goop.org ([64.81.55.164]:37553 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992974AbXDYTSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:18:50 -0400
Message-ID: <462FA9BD.5020000@goop.org>
Date: Wed, 25 Apr 2007 12:19:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> Hm, but it should be overwriting small mappings with large ones.  Maybe
>> I overlooked that.
>>     
>
> Nope.  It's not overwriting anything.

It will work if we just overwrite the pmd's with large pages in the PSE
case, since Xen doesn't support PSE.  Or we could only overwrite if its
!present or !huge.

>   I'm not at all convinced we
> should preserve the Xen sillyness.  I'm not exactly against it,
> but it adds complexity to already complex code.
>   

Yes.  I would love to see that code get simplified.  I've been trying to
walk a line of making my changes small and incremental, while still
trying to get a reasonable result.  In this case, its a file which has
undergone many such changes, and the entropy is really building up.

The Xen case is tricky because the hypervisor is very strict about what
can be in the pagetable, and so we can't go through any transitional bad
states on the way to constructing the final result.  The easiest way to
do that is use the existing pagetable where possible and just add new
things to it.

> We will have to see.  Currently the paravirt pagetable setup clashes
> horrible with actually running a kernel on real hardware.
>   

I'll fix it up.  I've been running these kernels on my normal work
machine without obvious problems, which is why it escaped notice until
HPA's debug patch.

> Color me not impressed by the paravirt mess.

Well, I'm working on it :)

    J

