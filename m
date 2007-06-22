Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXFVLyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXFVLyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXFVLyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:54:41 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:54168 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752600AbXFVLyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:54:39 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: John Johansen <jjohansen@suse.de>
Cc: Lars Marowsky-Bree <lmb@suse.de>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070622080640.GB14593@suse.de>
References: <20070615200623.GA2616@elf.ucw.cz>
	 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
	 <20070616000251.GG2616@elf.ucw.cz>
	 <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
	 <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	 <20070622080640.GB14593@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 22 Jun 2007 07:53:47 -0400
Message-Id: <1182513228.24664.24.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 01:06 -0700, John Johansen wrote:
> On Thu, Jun 21, 2007 at 04:59:54PM -0400, Stephen Smalley wrote:
> > On Thu, 2007-06-21 at 21:54 +0200, Lars Marowsky-Bree wrote:
> > > On 2007-06-21T15:42:28, James Morris <jmorris@namei.org> wrote:
> > > 
> > 
> > > And now, yes, I know AA doesn't mediate IPC or networking (yet), but
> > > that's a missing feature, not broken by design.
> > 
> > The incomplete mediation flows from the design, since the pathname-based
> > mediation doesn't generalize to cover all objects unlike label- or
> > attribute-based mediation.  And the "use the natural abstraction for
> > each object type" approach likewise doesn't yield any general model or
> > anything that you can analyze systematically for data flow.
> > 
> No the "incomplete" mediation does not flow from the design.  We have
> deliberately focused on doing the necessary modifications for pathname
> based mediation.  The IPC and network mediation are a wip.

The fact that you have to go back to the drawing board for them is that
you didn't get the abstraction right in the first place.

> We have never claimed to be using pathname-based mediation IPC or networking.
> The "natural abstraction" approach does generize well enough and will
> be analyzable.

I think we must have different understandings of the words "generalize"
and "analyzable".  Look, if I want to be able to state properties about
data flow in the system for confidentiality or integrity goals (my
secret data can never leak to unauthorized entities, my critical data
can never be corrupted/tainted by unauthorized entities - directly or
indirectly), then I need to be able to have a common reference point for
my policy.  When my policy is based on different abstractions
(pathnames, IP addresses, window ids, whatever) for different objects,
then I can no longer identify how data can flow throughout the system in
a system-wide way. 

> > Um, no.  It might not be able to directly open files via that path, but
> > showing that it can never read or write your mail is a rather different
> > matter.
> > 
> Actually it can be analyzed and shown.  It is ugly to do and we
> currently don't have a tool capable of doing it, but it is possible.

No, it isn't possible when using ambiguous and unstable identifiers for
the subjects and objects, nor when mediation is incomplete.

-- 
Stephen Smalley
National Security Agency

