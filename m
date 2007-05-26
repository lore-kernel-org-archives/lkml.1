Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXEZLqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXEZLqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 07:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXEZLqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 07:46:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXEZLqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 07:46:42 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 13:46:20 +0200
User-Agent: KMail/1.9.5
Cc: casey@schaufler-ca.com, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
In-Reply-To: <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2774
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705261346.20712.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 07:20, Kyle Moffett wrote:
> On May 24, 2007, at 14:58:41, Casey Schaufler wrote:
> > On Fedora zcat, gzip and gunzip are all links to the same file.  I  
> > can imagine (although it is a bit of a stretch) allowing a set of  
> > users access to gunzip but not gzip (or the other way around).
> 
> That is a COMPLETE straw-man argument.  I can override your "check"  
> with this absolutely trivial perl code:
> 
> exec { "/usr/bin/gunzip" } "gzip", "-9", "some/file/to.gz";

The above Perl code executes /usr/bin/gunzip and sets argv[0] to "gzip", so 
this confirms that the value of argv[0] is arbitrary. Well great, we already 
knew.

> Pathname-based checks are pretty fundamentally insecure.

Please don't mix apples and pears. Some utilities change their behavior based 
on argv[0], which indeed is not secure. It doesn't have to be for those 
utilities' needs. This is different from pathname-based access control, which 
is based on the pathname of the binary actually being executed.

AppArmor does not look at argv[0] for anything, and doing so would be insane. 
So please don't jump to the wrong conclusions.

You can have application-level argv[0] checks in the binary that is hardlinked 
to /bin/gzip, /bin/gunzip, /bin/zcat. At the same time, the kernel knows 
which of these three versions it is executing, so from that point of view, 
they could be as well be separate copies, and different policy can be defined 
for each one of them. (This is ignoring the fact that for small utilities 
like gzip, profile inheritance is usually more useful than defining separate 
profiles.)

Thanks,
Andreas
