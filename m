Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbXEXSKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbXEXSKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXEXSKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:10:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:36874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXEXSKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:10:18 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: James Morris <jmorris@namei.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Thu, 24 May 2007 20:10:00 +0200
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@ftp.linux.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200705241112.41101.agruen@suse.de> <Line.LNX.4.64.0705240858190.6121@d.namei>
In-Reply-To: <Line.LNX.4.64.0705240858190.6121@d.namei>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3593
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705242010.00961.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 15:19, James Morris wrote:
> On Thu, 24 May 2007, Andreas Gruenbacher wrote:
> > > Would you mind providing some concrete examples of how such a model
> > > would be useful?
> >
> > The model is explained, with examples, in the technical documentation at
> > http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/.
>
> I'm asking specifically about a model where you'd want to provide
> differing access to the same objects based on the pathname used for
> access to the objects, per:
>
>   "If files are mounted at multiple locations, then the policy may allow
>    access to some locations but not to others.  That's not a hole."
>
> I don't see specific examples of this kind of policy in that document,

I guess I see what you are getting at. If a user has read/write access 
to /views/sysadmin/etc/shadow and if that is an alias for /etc/shadow, then 
of course it doesn't help to give the user only read access to /etc/shadow to 
protect that file. So you can shoot yourself in the foot with mounts, and 
also with hardlinks. That's why confined processes are not allowed to mount 
stuff, and why hardlinks requires the appropriate profile permissions.

AppArmor depends on the namespace so it cares about namespace manipulations,  
just like SELinux depends on labels so labels matter there.

> and the document seems to be saying quite the opposite -- that the AA
> policy is only valid in conjunction with further constraints on how the
> objects may be accessed:

Read it like this: we don't have a good idea how to support multiple 
namespaces so far. Currently, we interpret all pathnames relative to the 
namespace a process is in. Confined processes don't have the privilege to 
create or manipulate namespaces, which makes this safe. We may find a better 
future solution.

> I can restate my question and ask why you'd want a security policy like:
>
>   Subject 'sysadmin' has:
>      read access to /etc/shadow
>      read/write access to /views/sysadmin/etc/shadow
>
> where the objects referenced by the paths are identical and visible to the
> subject along both paths, in keeping with your description of "policy may
> allow access to some locations but not to others" ?

I'm not aware of situations where giving different permissions to different  
paths to the same file would actually be useful. The security model doesn't  
prevent it though, and it's not a security hole.

Andreas
