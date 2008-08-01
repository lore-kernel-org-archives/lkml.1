Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbYHAOsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbYHAOsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYHAOrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:47:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39810 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYHAOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:47:55 -0400
Date: Fri, 1 Aug 2008 15:47:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>, Gene Heskett <gene.heskett@gmail.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
Message-ID: <20080801144748.GO28946@ZenIV.linux.org.uk>
References: <200807302254.26036.gene.heskett@gmail.com> <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au> <200807310909.27619.gene.heskett@gmail.com> <1217515455.2902.94.camel@localhost.localdomain> <1217595068.20373.307.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217595068.20373.307.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 08:51:08AM -0400, Stephen Smalley wrote:
> 
> On Thu, 2008-07-31 at 10:44 -0400, Eric Paris wrote:
> > On Thu, 2008-07-31 at 09:09 -0400, Gene Heskett wrote:
> > > On Thursday 31 July 2008, James Morris wrote:
> > 
> > > >What AVC messages are you seeing?
> > > 
> > > I posted the whole screen from setroubleshoot earlier.
> > 
> > I'm sorry but I can't seem to find it in your original message...
> > 
> > http://marc.info/?l=linux-kernel&m=121747333012971&w=2
> > 
> > Do you have another pointer?  I can't think of anything that went into
> > 2.6.27 related to SELinux that should have in any way changed file
> > access checks but I'll poke through the changelog and see if something
> > stands out...
> 
> It could be the append bug introduced by the vfs changes.
> See:
> http://marc.info/?l=linux-kernel&m=121726661110266&w=2
> 
> That would break any case where only append permission is granted (not
> full write access), as would be typical for httpd log files.

commit d54bb7a971b41b8a4baba6e3d9adf14ce035947f
Author: Stephen Smalley <sds@tycho.nsa.gov>
Date:   Mon Jul 28 13:32:38 2008 -0400

    Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree
    for July 17: early crash on x86-64)

in vfs-2.6.git/for-next (and for-linus as well)
