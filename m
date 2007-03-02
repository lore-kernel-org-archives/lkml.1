Return-Path: <linux-kernel-owner+w=401wt.eu-S1422900AbXCBGpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422900AbXCBGpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422960AbXCBGpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:45:36 -0500
Received: from gw.goop.org ([64.81.55.164]:36247 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422900AbXCBGpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:45:35 -0500
Message-ID: <45E7C80E.1020107@goop.org>
Date: Thu, 01 Mar 2007 22:45:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org> <45E79C72.4000806@goop.org> <45E7C4DD.1040403@vmware.com>
In-Reply-To: <45E7C4DD.1040403@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Yeah, actually that does work, since you pass the km_type, we can use
> that.  But I would rather not respin this for 2.6.21; getting this
> 100% right can be tricky, and we've already done a good deal of
> testing on this patch the way it is.

It seems fairly low risk to me; its basically the same structure with
the same calls happening in the same order, but just slightly rearranged
in the source.  Of course, if I'd seen this patch earlier I could have
given you earlier feedback...

>   Do you have any objection to me creating a patch for -mm tree that
> implements kmap_atomic_pte the way you have described above and
> attaching it to the Xen patch series, but leaving the current patch as
> is for now?

Not particularly, but it seems odd to put something in knowing its going
to be immediately replaced.  What's the urgency?

> Thanks, (and thanks for the suggestion - I was a little worried about
> how it would play with Xen when HIGHPTE support came around, but it
> looks like it will work for both of us with just one paravirt-op).

Yeah, the kpte_clear_flush change helped as well.  I have a patch to
make that into a pvop as well, since its useful to do the clear+flush in
a single call.

    J
