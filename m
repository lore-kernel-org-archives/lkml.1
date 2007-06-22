Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXFVNWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXFVNWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFVNWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:22:30 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:45731 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751278AbXFVNW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:22:29 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070622125457.GS20105@marowsky-bree.de>
References: <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
	 <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	 <20070621211743.GN20105@marowsky-bree.de>
	 <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
	 <20070622113727.GJ20105@marowsky-bree.de>
	 <1182516111.24664.72.camel@moss-spartans.epoch.ncsc.mil>
	 <20070622125457.GS20105@marowsky-bree.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 22 Jun 2007 09:22:19 -0400
Message-Id: <1182518539.24664.95.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 14:54 +0200, Lars Marowsky-Bree wrote:
> On 2007-06-22T08:41:51, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > Sorry, do you mean the "server" as in the "server system" or as in the
> > "server daemon"?  For the former, I'd agree - we would want SELinux
> > policy applied on the server as well as the client to ensure that the
> > data is being protected consistently throughout and that the server is
> > not misrepresenting the security guarantees expected by the clients.
> > Providing an illusion of confinement on each client without any
> > corresponding protection on the server system would be very prone to
> > bypass.  For the latter, the kernel can only truly confine application
> > code, not in-kernel threads, although we can subject the in-kernel nfsd
> > to permission checking as a robustness check.  We've always noted that
> > SELinux does depend on the correctness of the kernel.
> 
> Oh, you're saying that this threat is out-of-scope? ;-)

Kernel flaws aren't something we can address (reliably and in general)
via a kernel mechanism.  Versus a threat that can be addressed by kernel
mechanism, like providing complete mediation and unambiguous access
control.  There is a difference.  And we aren't ignoring the kernel
correctness problem - there is separate work in that space, but it
requires separate mechanism outside of SELinux itself.

> Note that here we've already strayed from the focus of the discussion;
> we're no longer arguing "the implementation is ugly/broken", but you're
> claiming "doesn't do what I need" - which I'm not disagreeing with. It
> doesn't do what you want. Which is why you have SELinux, and it's going
> to stay. Fine.
> 
> If we assume that the users who run it do have a need / use case for it
> which they can't solve differently, we should really get back to the
> discussion of how those needs can be met or provided by Linux in a
> feasible way.

Part of the discussion has been whether those users' needs could be
solved better via SELinux, whether via improved userspace tools (ala
seedit possibly with an enhanced restorecond) or via extended kernel
mechanism (ala named type transitions and some kind of inheritance
model).  It does however seem like there is a fundamental conflict there
on renaming behavior; I do not believe that file protections should
automatically change in the kernel upon rename and should require
explicit userspace action.  The question though is whether that renaming
behavior in AA is truly a user requirement or a manufactured (i.e.
made-up) one, and whether it is truly a runtime requirement or just a
policy creation time one (the latter being adequately addressed by
userspace relabeling).

If that behavior is truly needed (a point I wouldn't concede), then the
discussion does reduce down to the right implementation method.  There
it appears that the primary objection is to regenerating full pathname
strings and matching them versus some kind of incremental matching
either during lookup itself or via a reverse match as suggested.  That
discussion is principally one in which the vfs folks should be engaged,
not me.

> > > Your use case mandates complete system-wide mediation, because you want
> > > full data flow analysis. Mine doesn't.
> > Then yours isn't mandatory access control, nor is it confinement.  
> 
> I apologize for not using the word "confinement" in the way you expect
> it to be used. I certainly don't want to imply it does do things it
> doesn't. Keep in mind I'm not a native speaker, so nuances do get lost
> sometimes; nor do I have long years of experience in the security
> field. Thanks for clearing this up.
> 
> So agreed, it is not confinement nor MAC.
> 
> Would it be more appropriate if I used the word "restricts" or
> "constrains"?

Yes.  Or simply "controls file accesses and capability usage".

-- 
Stephen Smalley
National Security Agency

