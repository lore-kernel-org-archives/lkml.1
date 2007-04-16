Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXDPJfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXDPJfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXDPJfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:35:52 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:33634 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbXDPJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:35:51 -0400
To: linuxram@us.ibm.com
CC: devel@openvz.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <1176713221.9488.17.camel@ram.us.ibm.com> (message from Ram Pai
	on Mon, 16 Apr 2007 01:47:00 -0700)
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	 <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com> <1176713221.9488.17.camel@ram.us.ibm.com>
Message-Id: <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Apr 2007 11:32:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Given the existence of shared subtrees allowing/denying this at the
> > mount
> > namespace level is silly and wrong.
> > 
> > If we need more than just the filesystem permission checks can we
> > make it a mount flag settable with mount and remount that allows
> > non-privileged users the ability to create mount points under it
> > in directories they have full read/write access to.
> 
> Also for bind-mount and remount operations the flag has to be propagated
> down its propagation tree.  Otherwise a unpriviledged mount in a shared
> mount wont get reflected in its peers and slaves, leading to unidentical
> shared-subtrees.

That's an interesting question.  Do we want shared mounts to be
totally identical, including mnt_flags?  It doesn't look as if
do_remount() guarantees that currently.

Miklos
