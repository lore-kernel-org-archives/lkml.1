Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbXFUVAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbXFUVAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXFUVAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:00:08 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:47025 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756220AbXFUVAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:00:05 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070621195400.GK20105@marowsky-bree.de>
References: <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com>
	 <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com>
	 <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
	 <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 21 Jun 2007 16:59:54 -0400
Message-Id: <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 21:54 +0200, Lars Marowsky-Bree wrote:
> On 2007-06-21T15:42:28, James Morris <jmorris@namei.org> wrote:
> 
> > > A veto is not a technical argument. All technical arguments (except for
> > > "path name is ugly, yuk yuk!") have been addressed, have they not?
> > AppArmor doesn't actually provide confinement, because it only operates on 
> > filesystem objects.
> > 
> > What you define in AppArmor policy does _not_ reflect the actual 
> > confinement properties of the policy.  Applications can simply use other 
> > mechanisms to access objects, and the policy is effectively meaningless.
> 
> Only if they have access to another process which provides them with
> that data.

Or can access the data under a different path to which their profile
does give them access, whether in its final destination or in some
temporary file processed along the way.

> And now, yes, I know AA doesn't mediate IPC or networking (yet), but
> that's a missing feature, not broken by design.

The incomplete mediation flows from the design, since the pathname-based
mediation doesn't generalize to cover all objects unlike label- or
attribute-based mediation.  And the "use the natural abstraction for
each object type" approach likewise doesn't yield any general model or
anything that you can analyze systematically for data flow.

The emphasis on never modifying applications for security in AA likewise
has an adverse impact here, as you will ultimately have to deal with
application mediation of access to their own objects and operations not
directly visible to the kernel (as we have already done in SELinux for
D-BUS and others and are doing for X).  Otherwise, your "protection" of
desktop applications is easily subverted.

> > You might define this as a non-technical issue, but the fact that AppArmor 
> > simply does not and can not work is a fairly significant consideration, I 
> > would imagine.
> 
> If I restrict my Mozilla to not access my on-disk mail folder, it can't
> get there. (Barring bugs in programs which Mozilla is allowed to run
> unconfined, sure.)

Um, no.  It might not be able to directly open files via that path, but
showing that it can never read or write your mail is a rather different
matter.

-- 
Stephen Smalley
National Security Agency

