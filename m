Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXDPJuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXDPJuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030301AbXDPJuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:50:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35696 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030307AbXDPJuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:50:50 -0400
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: devel@openvz.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
References: <20070412164541.580374744@szeredi.hu>
	 <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 02:49:01 -0700
Message-Id: <1176716941.9488.57.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 11:32 +0200, Miklos Szeredi wrote:
> > > Given the existence of shared subtrees allowing/denying this at the
> > > mount
> > > namespace level is silly and wrong.
> > > 
> > > If we need more than just the filesystem permission checks can we
> > > make it a mount flag settable with mount and remount that allows
> > > non-privileged users the ability to create mount points under it
> > > in directories they have full read/write access to.
> > 
> > Also for bind-mount and remount operations the flag has to be propagated
> > down its propagation tree.  Otherwise a unpriviledged mount in a shared
> > mount wont get reflected in its peers and slaves, leading to unidentical
> > shared-subtrees.
> 
> That's an interesting question.  Do we want shared mounts to be
> totally identical, including mnt_flags?  It doesn't look as if
> do_remount() guarantees that currently.

Depends on the semantics of each of the flags. Some flags like of the
read/write flag, would not interfere with the propagation semantics
AFAICT.  But this one certainly seems to interfere.

RP

> Miklos

