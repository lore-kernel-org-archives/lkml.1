Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbXJRPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbXJRPal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbXJRPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:30:29 -0400
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:37894 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756790AbXJRPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:30:27 -0400
X-YMail-OSG: 20FakUwVM1mimRZJPtctBLutUwf2Nj5tnHCSbF0Vs9._8Qpxbt5cTh25FFYD3S44yft8xCRkaw--
Date: Thu, 18 Oct 2007 10:30:23 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaigai@kaigai.gr.jp, casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-ID: <20071018153023.GA12123@vino.hallyn.com>
References: <20071016022730.GA8925@sergelap.austin.ibm.com> <20071016023100.GA10698@sergelap.austin.ibm.com> <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil> <20071016214159.GB13294@sergelap.austin.ibm.com> <20071017180002.33fe4986.akpm@linux-foundation.org> <20071018025920.GA5067@vino.hallyn.com> <20071018052111.GQ3906@sequoia.sous-sol.org> <20071018125026.GA10387@vino.hallyn.com> <47177B65.7040408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47177B65.7040408@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> > Quoting Chris Wright (chrisw@sous-sol.org):
> >> * Serge E. Hallyn (serge@hallyn.com) wrote:
> >>> I guess now that I've written this out, it seems pretty clear
> >>> that capget64() and capget64() are the way to go.  Any objections?
> >> How is capget64() different from capget() that supports 2 different
> >> header->versions (I thought that was the whole point of the versioned,
> >> rather opaque interface)?  I don't object to a new syscall, but I don't
> >> see why it's required to avoid breaking libcap.
> > 
> > Hmm, I guess it *works*, it's just harder to explain the "inconsistent"
> > behavior.  Now instead of saying "capget() will fail under certain
> > conditions while capget64() will always succeed", capget() will actually
> > fail under certain conditions only if you send in a certain header.
> > 
> > Again, once I've written it out, I guess it isn't *so* bad.
> 
> [I'm just wading back into a mass of neglected email. Long story.]
> 
> Chris is right, this is precisely why the interface is versioned, and
> there is at least one version of libcap that was written to support this
> versioning scheme

Ok - i actually didn't default to backward compatibility because I was
pretty sure you would object to it on the grounds that old userspace
might get unexpected behavior.  But I guess since all high caps should be
new ones for new features, it'll require new userspace to exploit
anyway.

> cvs -z3
> - -d:pserver:anonymous@cvs.linux-privs.sourceforge.net:/cvsroot/linux-privs
> co -r libcap-pre2 libcap
> 
> I'll try and unwind all the threads of email I've been neglecting and
> have something useful to say over the next few days.

Thanks.  I'll try to get a backward-compatible patch out today (again
just for rfc)  If not today, at least tomorrow.

thanks,
-serge
