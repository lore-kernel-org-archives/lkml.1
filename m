Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYFCGJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYFCGJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYFCGJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:09:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44994 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYFCGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:09:43 -0400
To: haradats@gmail.com
CC: johnpol@2ka.mipt.ru, miklos@szeredi.hu, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <9d732d950806021637q5527398boad7cb54ae5f26662@mail.gmail.com>
	(haradats@gmail.com)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080602091341.GA8011@infradead.org>
	 <20080602093630.GA25254@infradead.org>
	 <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
	 <20080602104203.GA21898@infradead.org>
	 <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
	 <20080602150517.GB22400@2ka.mipt.ru>
	 <9d732d950806020831h1b8aeabag9cb6db8e16bac971@mail.gmail.com>
	 <20080602155152.GA18257@2ka.mipt.ru>
	 <9d732d950806020929v1ece55ecobabc418425c1e044@mail.gmail.com>
	 <20080602165223.GA9121@2ka.mipt.ru> <9d732d950806021637q5527398boad7cb54ae5f26662@mail.gmail.com>
Message-Id: <E1K3PhM-00056I-K1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jun 2008 08:08:44 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, another option has been suggested last month.
> http://lkml.org/lkml/2008/4/9/93

Yes, thanks for the link.

Here's the relevant quote from that mail from Stephen Smalley:

 "2) Submit patches to add new security hooks to the callers where the
  vfsmount is already available (some have suggested moving the
  existing security_inode hooks to the callers, but that would cause
  problems for SELinux as I've posted elsewhere, so adding new hooks
  is preferable, and then SELinux can just default to the dummy
  functions for those new hooks)."

True, this is an alternative, but from the VFS point of view it's
actually _worse_ than moving the hooks out, since we now have two sets
of security hooks littering the code for no good reason.

If Matthew Wilcox's idea can be made to work, that's obviously the
best, since it means that the VFS doesn't need to be touched at all.

Otherwise passing down vfsmounts is a superior solution to everything
else.  It has *absolutely* *no* downsides.  None, zero, zilch.

Well apart from the matter of VFS maintainers opinions.  But damit,
this is an open source project, where decisions are made on technical
merit, and not on personal whims.

If the VFS maintainers don't like it, they better state their reasons
in clear and concise terms.  An no, things like "someone might perhaps
maybe in the future need to call the vfs without a vfsmount" is
absolutely not a good reason.  When we have such a caller, we'll fix
the code.  It happens all the time.  Prepering for everything that
might happen is called overdesign and it's one of the worst and
commonest mistakes in software engineering.

Miklos
