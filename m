Return-Path: <linux-kernel-owner+w=401wt.eu-S2992729AbXDRPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992729AbXDRPHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXDRPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:07:50 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:53935 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992728AbXDRPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:07:49 -0400
To: trond.myklebust@fys.uio.no
CC: ebiederm@xmission.com, serue@us.ibm.com, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1176906389.6796.96.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Wed, 18 Apr 2007 10:26:29 -0400)
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
References: <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	 <1176716941.9488.57.camel@ram.us.ibm.com>
	 <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	 <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
	 <E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
	 <m1zm58jfj3.fsf@ebiederm.dsl.xmission.com>
	 <20070416195652.GA350@sergelap.austin.ibm.com>
	 <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
	 <E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
	 <m1zm56j27m.fsf@ebiederm.dsl.xmission.com>
	 <E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu>
	 <m1vefuixp5.fsf@ebiederm.dsl.xmission.com>
	 <E1He6C7-0003Xu-00@dorka.pomaz.szeredi.hu>
	 <1176904505.6796.79.camel@heimdal.trondhjem.org>
	 <E1HeAkl-000490-00@dorka.pomaz.szeredi.hu> <1176906389.6796.96.camel@heimdal.trondhjem.org>
Message-Id: <E1HeBjt-0004G8-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Apr 2007 17:06:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Don't forget that almost all mount flags are per-superblock. How are you
> > > planning on dealing with the case that one user mounts a filesystem
> > > read-only, while another is trying to mount the same one read-write?
> > 
> > Yeah, I forgot, the per-mount read-only patches are not yet in.
> > 
> > That doesn't really change my agrument though.  _If_ the flag is per
> > mount, then it makes sense to be able to change it on a master and not
> > on a slave.  If mount flags are propagated, this is not possible.
> 
> Read-only isn't the only issue. On something like NFS, there are flags
> to set the security flavour, turn on/off encryption etc.
> 
> If I mount your home directory using no encryption in my namespace, for
> instance, then neither you nor the administrator will be able to turn it
> on afterwards in yours without first unmounting it from mine so that the
> superblock is destroyed.

OK, that's interesting, but I fail to grasp the relevance of this to
unprivileged mounts.

Or are you thinking of unprivileged NFS mounts?  Well, think again,
because that involves _much_ more than it seems at first glance.

Miklos
