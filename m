Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXF0RVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXF0RVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXF0RVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:21:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46648 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763AbXF0RVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:21:06 -0400
Date: Wed, 27 Jun 2007 12:21:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070627172102.GB16764@sergelap.austin.ibm.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com> <20070627134149.GB2679@sergelap> <Line.LNX.4.64.0706271031220.5258@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706271031220.5258@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 27 Jun 2007, Serge E. Hallyn wrote:
> 
> > Quoting Kyle Moffett (mrmacman_g4@mac.com):
> > > This whole discussion boils down to 2 points:
> > 
> > Yes it can, but not the two you list.
> > 
> > >   1) As currently implemented, no LSM may be safely rmmod-ed
> > 
> > That's not the rationale for the patch, it's just some talking point you
> > picked up.  The rationale for the patch is to prevent abuse.
> 
> This is not correct.  Reducing API abuse is simply a bonus.
> 
> The rationale for the patch is to remove unneeded infrastructure which 
> complicates security by introducing the idea that the security module can 
> be removed at all.
> 
> It was in response to your very own posting about the new capabilities 
> code which would need to take this into account.

It's (IMO) by far not the optimal "solution"  :)  If it is felt a
solution is really needed, re-introduction of a
security_ops->module_exit hook and introduction of CAP_SYS_CAPDISABLE
would be better.

But I'm well aware there are far too many (separate and not so separate)
agendas driving this, and have no expectations of being able to stop it.

James, FWIW, I'm sorry I haven't had a chance to actually test the
patch.  I'll try to get around to that today or at least this week.

-serge

> Recall:
> 
> On Sun, 24 Jun 2007, Serge E. Hallyn wrote:
> 
> > > 2) Allocate capability bit-31 for CAP_SETFCAP, and use it to gate
> > > whether the user can set this xattr on a file or not. CAP_SYS_ADMIN is
> > > way too overloaded and this functionality is special.
> > 
> > The functionality is special, but someone with CAP_SYS_ADMIN can always
> > unload the capability module and create the security.capability xattr
> > using the dummy module.
> > 
> > If we do add this cap, do we want to make it apply to all security.*
> > xattrs?
> 
> The underlying issue here is the notion of security mechanisms which are 
> built as loadable modules.  It's not useful for any in-tree users, and 
> introduces several unnecessary problems which then need to be addressed.
> 
> A better approach would be to make LSM a statically linked interface.
> 
> This would also allow us to unexport the LSM symbols and reduce the API 
> abuse by third-party modules.
> 
> 
> 
> - James
> -- 
> James Morris
> <jmorris@namei.org>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
