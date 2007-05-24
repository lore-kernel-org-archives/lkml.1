Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXEXNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXEXNTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbXEXNTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:19:40 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:53706 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbXEXNTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:19:39 -0400
Date: Thu, 24 May 2007 09:19:35 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andreas Gruenbacher <agruen@suse.de>
cc: Al Viro <viro@ftp.linux.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <200705241112.41101.agruen@suse.de>
Message-ID: <Line.LNX.4.64.0705240858190.6121@d.namei>
References: <20070412090809.917795000@suse.de> <200705232106.28260.agruen@suse.de>
 <Line.LNX.4.64.0705232109030.3178@d.namei> <200705241112.41101.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Andreas Gruenbacher wrote:

> > Would you mind providing some concrete examples of how such a model would
> > be useful?
> 
> The model is explained, with examples, in the technical documentation at http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/.

I'm asking specifically about a model where you'd want to provide 
differing access to the same objects based on the pathname used for 
access to the objects, per:

  "If files are mounted at multiple locations, then the policy may allow 
   access to some locations but not to others.  That's not a hole."

I don't see specific examples of this kind of policy in that document, 
and the document seems to be saying quite the opposite -- that the AA 
policy is only valid in conjunction with further constraints on how the 
objects may be accessed:

Section 3.2:

 "Pathnames are meaningful only within a namespace. Each namespace has a 
  root where all the files, directories, and mount points are hanging off 
  from.

  The privilege of creating new namespaces is bound to the CAP_ SYS_ ADMIN 
  capability, which grants a multitude of other things that would allow a 
  process to break out of AppArmor confinement, so confined processes are 
  not supposed to have this privilege, and processes with this capability 
  need to be considered trusted. "


I can restate my question and ask why you'd want a security policy like:

  Subject 'sysadmin' has:
     read access to /etc/shadow
     read/write access to /views/sysadmin/etc/shadow

where the objects referenced by the paths are identical and visible to the 
subject along both paths, in keeping with your description of "policy may 
allow access to some locations but not to others" ?


- James
-- 
James Morris
<jmorris@namei.org>
