Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYFDIpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYFDIpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYFDIpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:45:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55005 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYFDIpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:45:08 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@lst.de, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <cfd18e0f0806040143x6343194bl2b7b0111cc84375f@mail.gmail.com>
	(mtk.manpages@googlemail.com)
Subject: Re: [parch 4/4] vfs: utimensat(): fix write access check for futimens()
References: <4845C4D2.8050408@gmail.com>
	 <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu>
	 <E1K3lxO-0007t2-2d@pomaz-ex.szeredi.hu> <cfd18e0f0806040143x6343194bl2b7b0111cc84375f@mail.gmail.com>
Message-Id: <E1K3obn-0008HS-Sl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 10:44:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 4, 2008 at 7:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> At which point the "if (f)" and the "else" branches become equivalent
> >> (the nameidata isn't interesting in the other case either).  So that
> >> could be written as:
> >>
> >>               if (!is_owner_or_cap(inode)) {
> >>                       error = permission(inode, MAY_WRITE, NULL);
> >>                       if (error)
> >>                               goto mnt_drop_write_and_out;
> >>               }
> >
> > And also the IS_IMMUTABLE() check can be removed, since it's checked
> > by permission(MAY_WRITE) anyway.
> 
> I'm not sure that that is true, because immutability applies
> regardless of capabilities or ownership, right?

Yeah, you're right.  I misread that.

Miklos
