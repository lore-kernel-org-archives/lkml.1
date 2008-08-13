Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYHMM5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYHMM5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYHMM46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:56:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3632 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbYHMM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:56:57 -0400
Date: Wed, 13 Aug 2008 14:56:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: davecb@sun.com, Arjan van de Ven <arjan@infradead.org>,
       Mihai Don??u <mdontu@bitdefender.com>, Adrian Bunk <bunk@kernel.org>,
       tvrtko.ursulin@sophos.com, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Message-ID: <20080813125638.GB6995@ucw.cz>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <200808070349.55882.mdontu@bitdefender.com> <20080806213904.37a33a58@infradead.org> <200808111645.48177.mdontu@bitdefender.com> <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com> <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com> <20080813102802.GC27074@atrey.karlin.mff.cuni.cz> <2629CC4E1D22A64593B02C43E855530304AE4BA4@USILMS12.ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BA4@USILMS12.ca.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > Proposed kernel solution did not work -- there still was write
> > vs. read race. You are right that it is not ok for each application to
> > do its own malware scanning, but libmalware.so that handles the
> > scanning seems very reasonable.
> > 
> > And as applications _need_ to be modified for the write vs. read race
> > to be solved, libmalware.so looks like a way forward.
> 
> I am not sure what you are suggesting, and I may have missed the
> libmalware proposal (I don't see any mention of that specific idea in
> any other message).  However, just to be clear...  At no point did we
> suggest that the kernel would do any scanning.  What we have been
> interested in is a mechanism that can allow a scanning application to be
> notified by the kernel of specific i/o events, for those events to be
> blocked by the kernel until a user-space scan is done, and then the
> user-space scan sends back allow or deny, at which point the i/o event
> returns to the caller -- either success or error.  This is the only way
> that malware can be guaranteed of being detected when it is used (for
> local application purposes or for transmission to another platform) or
> created.  

As I said, that does not work. Proposed solution blocked open, while
you'd have to block read() and you still could not handle mmap.
So sorry, no kernel solution can work.

> Also, a solution that requires applications to be modified will not
> work, because there is no way that we would be able to get ALL
> applications on the machines to be modified in the required ways.  If
> ANY applications are not so modified, then you have an unacceptable
> malware hole.  The only solution that really works is one that

So you make sure all apps are modified. Distros are good at that, and
modifications are not that hard.

Plus, proposed solution already has three unacceptable holes:

1) it only catches known signatures

2) write vs. read race mentioned above

3) mmap problem

. Making sure all apps use libmalware.so is trivial compared to
solving 3).

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
