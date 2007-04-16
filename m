Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXDPJ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXDPJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXDPJ5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:57:24 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:40242 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295AbXDPJ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:57:23 -0400
To: linuxram@us.ibm.com
CC: miklos@szeredi.hu, devel@openvz.org, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <1176716941.9488.57.camel@ram.us.ibm.com> (message from Ram Pai
	on Mon, 16 Apr 2007 02:49:01 -0700)
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	 <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu> <1176716941.9488.57.camel@ram.us.ibm.com>
Message-Id: <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Apr 2007 11:56:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Also for bind-mount and remount operations the flag has to be propagated
> > > down its propagation tree.  Otherwise a unpriviledged mount in a shared
> > > mount wont get reflected in its peers and slaves, leading to unidentical
> > > shared-subtrees.
> > 
> > That's an interesting question.  Do we want shared mounts to be
> > totally identical, including mnt_flags?  It doesn't look as if
> > do_remount() guarantees that currently.
> 
> Depends on the semantics of each of the flags. Some flags like of the
> read/write flag, would not interfere with the propagation semantics
> AFAICT.  But this one certainly seems to interfere.

That depends.  Current patches check the "unprivileged submounts
allowed under this mount" flag only on the requested mount and not on
the propagated mounts.  Do you see a problem with this?

Miklos
