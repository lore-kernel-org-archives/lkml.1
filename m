Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYHAOCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYHAOCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYHAOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:02:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58703 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYHAOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:02:40 -0400
Date: Fri, 1 Aug 2008 15:02:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Gene Heskett <gene.heskett@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, aviro@redhat.com
Subject: Re: 2.6.27-rc1: strange fstab issue (Re: 2.6.27-rc1 + selinux new
	options = no httpd)
Message-ID: <20080801140223.GN28946@ZenIV.linux.org.uk>
References: <200807302254.26036.gene.heskett@gmail.com> <Xine.LNX.4.64.0808010559290.30244@us.intercode.com.au> <200808010017.28125.rjw@sisk.pl> <200808010939.04186.gene.heskett@gmail.com> <1217598479.2980.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217598479.2980.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 09:47:59AM -0400, Eric Paris wrote:
> On Fri, 2008-08-01 at 09:39 -0400, Gene Heskett wrote:
> > On Thursday 31 July 2008, Rafael J. Wysocki wrote:
> > Update by Gene below.
> > >On Thursday, 31 of July 2008, James Morris wrote:
> > >> On Thu, 31 Jul 2008, Gene Heskett wrote:
> > >> > >Which new options?
> > >> >
> > >> > Make xconfig-->security options:
> > >> >
> > >> > XFRM Networking security hooks
> > >> >
> > >> >  and several others just below it.  Unforch, I can't copy/paste the
> > >> > screen.
> > >>
> > >> I can't really imagine what that is (although if you enable the secmark
> > >> controls under the main SELinux menu, which are disabled by default,
> > >> there could be problems).
> > >
> > >On a possibly related note, I've been observing a strange issue on one of
> > >my test boxes with OpenSUSE 10.3 recently.   Namely, the fsck complains
> > >that there's no passno value in the fstab, although it obviously is present.
> > >
> > >Strangely enough, if the kernel is compiled with CONFIG_SECURITY_SELINUX
> > > unset, the fsck doesn't complain about the missing passno field any more.
> > >
> > >Thanks,
> > >Rafael
> > 
> > I just did a 2.6.27-rc1 rebuild on a pure, all defaults 'make oldconfig' from
> > my 2.6.26 final .config moved to that src tree.
> > 
> > httpd is still being denied access to its log files and dies during the bootup.
> > 
> > This is a showstopper for me.
> 
> Stephen Smalley just sent me a private note.  Apparently he is having
> e-mail trouble but he did point out the most likely problem.  Can you
> add the patch from
> 
> http://marc.info/?l=linux-kernel&m=121726661110266&w=2
> 
> And give it a whirl?  Sorry, but we think the problem is that the VFS
> stopped passing all of the relevant information down to the security
> system.  https is only allowed to append to its log files, not actually
> 'write.'  Since the VFS is longer differentiating those two operations
> you are getting then denial for write.
> 
> I'll try to get this pushed into linus's tree quickly.

It's in linux-next, BTW.  I'll push the next set to Linus in an hour or so.
