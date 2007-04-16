Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXDPIsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXDPIsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXDPIsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:48:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60952 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXDPIss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:48:48 -0400
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
From: Ram Pai <linuxram@us.ibm.com>
To: devel@openvz.org
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
References: <20070412164541.580374744@szeredi.hu>
	 <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 01:47:00 -0700
Message-Id: <1176713221.9488.17.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >> 
> >> If CLONE_NEWNS and CLONE_NEWNS_USERMNT are given to clone(2) or
> >> unshare(2), then allow user mounts within the new namespace.
> >> 
> >> This is not flexible enough, because user mounts can't be enabled
> for
> >> the initial namespace.
> >> 
> >> The remaining clone bits also getting dangerously few...
> >> 
> >> Alternatives are:
> >> 
> >>   - prctl() flag
> >>   - setting through the containers filesystem
> >
> > Sorry, I know I had mentioned it, but this is definately my least
> > favorite approach.
> >
> > Curious whether are any other suggestions/opinions from the
> containers
> > list?
> 
> Given the existence of shared subtrees allowing/denying this at the
> mount
> namespace level is silly and wrong.
> 
> If we need more than just the filesystem permission checks can we
> make it a mount flag settable with mount and remount that allows
> non-privileged users the ability to create mount points under it
> in directories they have full read/write access to.

Also for bind-mount and remount operations the flag has to be propagated
down its propagation tree.  Otherwise a unpriviledged mount in a shared
mount wont get reflected in its peers and slaves, leading to unidentical
shared-subtrees.

RP


> 
> I don't like the use of clone flags for this purpose but in this
> case the shared subtress are a much more fundamental reasons for not
> doing this at the namespace level.
> 
> Eric
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers 

