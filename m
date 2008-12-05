Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYLESVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYLESVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYLESVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:21:15 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:56003 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbYLESVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:21:14 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
To: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, Mikulas Patocka <mpatocka@redhat.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Reply-To: 7eggert@gmx.de
Date: Fri, 05 Dec 2008 19:21:06 +0100
References: <bFnGM-7mA-5@gated-at.bofh.it> <bFpyX-1jh-15@gated-at.bofh.it> <bFquY-2x2-5@gated-at.bofh.it> <bFsnc-51o-37@gated-at.bofh.it> <bFuyC-7Zt-11@gated-at.bofh.it> <bFvuI-L8-29@gated-at.bofh.it> <bFwTJ-2oc-13@gated-at.bofh.it> <bFxwq-3g7-1@gated-at.bofh.it> <bFxGa-3pz-1@gated-at.bofh.it> <bFHvW-7up-5@gated-at.bofh.it> <bFHPd-84I-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1L8fIY-0001ui-DV@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

>> Not when the fundamental design of the code is broken and trashes
>> performance.
> 
> Sorry but that's just not correct. There's nothing in late failing
> barriers that "trashes performance". The file system writers have 
> to be careful to handle it, but at least the current ones all do.

So let's keep requiring the "trashes performance" hacks, because they're
not directly in the barriers code? Hey, we nailed one foot to the ground,
and since it's not the nail's fault, let's do the same to the other foot?
It does not matter, since we can't move around right now, so it's a pretty
neat idea, isn't it?

> And also if someone writes a hypothetical fully asynchronously driven
> barrier based IO transaction system it would be still possible to handle
> the late failing barrier without too many complications.

You can just replace barriers with NOPs without too many complications,
because it only matters in cases of system failure. And even then,
it's only the difference between having a filesystem corruption and not
having it ... Who'd care?

> Also late failing barriers is pretty much the only sane way to implement
> barriers in software remapping schemes like DM and MD.

No, and seeing the same resubmit logic in more than one place should give
you the clue, even if you don't grasp that intermixing requests which
explicitely MUST NOT be intermixed is wrong.

The sane way is having a software barrier in DM and MD, going back to
sync if the new hardware does not support barriers in hardware. The
filesystems should not even need to know if barriers are supported, 
just use them and they'll DTRT in any case. Any other interface is
worse than useless.

