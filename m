Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXFVNsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXFVNsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXFVNsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:48:18 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:56161 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbXFVNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:48:16 -0400
Date: Fri, 22 Jun 2007 09:48:12 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070622121742.GC6222@think.oraclecorp.com>
Message-ID: <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
References: <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
 <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
 <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
 <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
 <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
 <20070622121742.GC6222@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Chris Mason wrote:

> > The validity or otherwise of pathname access control is not being 
> > discussed here.
> > 
> > The point is that the pathname model does not generalize, and that 
> > AppArmor's inability to provide adequate coverage of the system is a 
> > design issue arising from this.
> 
> I'm sorry, but I don't see where in the paragraphs above you aren't
> making a general argument against the pathname model.

There are two distinct concepts here.

A. Pathname labeling - applying access control to pathnames to objects, 
rather than labeling the objects themselves.

Think of this as, say, securing your house by putting a gate in the street 
in front of the house, regardless of how many other possible paths there 
are to the house via other streets, adjoining properties etc.

Pathname labeling and mediation is simply mediating a well-known path to 
the object.  In this analogy, object labeling would instead ensure that 
all of the accessible doors, windows and other entrances of the house were 
locked, so that someone trying to break in from the rear alley would 
not get in simply by bypassing the front gate and opening any door.

What you do with AppArmor, instead of addressing the problem, is just 
redefine the environment along the lines of "set your house into a rock 
wall so there is only one path to it".


B. Pathname access control as a general abstraction for OS security.

Which is what was being discussed above, in response to a question from 
Lars about technical issues, and that this _model_ doesn't generalize to 
the rest of the OS, regardless of whether you think the mechanism of 
pathname labeling itself is appropriate or not.

In any case, clarifying such a distinction should not obscure the central 
issue, which is: AppArmor's design is broken.

General users, many kernel developers, and even security researchers who 
have not yet looked under the covers [1], are probably unaware that the 
confinement claims being made about AppArmor's confinement capabilities 
are simply not possible with either its model or implementation.

To quote from:

http://www.novell.com/linux/security/apparmor/

  "AppArmor gives you network application security via mandatory access 
   control for programs, protecting against the exploitation of software 
   flaws and compromised systems. AppArmor includes everything you need to 
   provide effective containment for programs (including those that run as 
   root) to thwart attempted exploits and even zero-day attacks."

This is not accurate in any sense of the term containment of mandatory 
access control that I've previously encountered.

The fact that it doesn't work as expected does not arise simply from 
missing features or being "different".  It arises from the design of the 
system, which uses a pathname abstraction, where, even if we agree to 
ignore issue (1) above, still does not work, because only filesystem 
interactions are mediated.

AppArmor policy does not reflect the behavior of the system.

The "simple" policy that users can so effortlessly manipulate is simple 
because it is wrong, and deliberately so.

The design of the AppArmor is based on _appearing simple_, but at the 
expense of completeness and thus correctness.


[1] http://lkml.org/lkml/2007/4/19/357

  "My gosh, you're right.  What the heck?  With all due respect to the
   developers of AppArmor, I can't help thinking that that's pretty lame.
   I think this raises substantial questions about the value of AppArmor.
   What is the point of having a jail if it leaves gaping holes that
   malicious code could use to escape?

   And why isn't this documented clearly, with the implications fully
   explained?"  - David Wagner, http://www.cs.berkeley.edu/~daw/
     

Indeed.



- James
-- 
James Morris
<jmorris@namei.org>
