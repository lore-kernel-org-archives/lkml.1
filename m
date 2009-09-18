Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZIRTuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZIRTuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbZIRTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:50:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZIRTuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:50:09 -0400
Date: Fri, 18 Sep 2009 21:50:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
	(Was: Re: [PATCH] Remove broken by design and by implementation
	devtmpfs maintenance disaster)
Message-ID: <20090918195005.GA11726@elte.hu>
References: <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com> <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain> <20090918150541.GB9307@kroah.com> <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com> <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, Sep 18, 2009 at 17:37, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Fri, Sep 18, 2009 at 17:05, Greg KH <greg@kroah.com> wrote:
> >> On Fri, Sep 18, 2009 at 07:18:54AM -0700, Linus Torvalds wrote:
> >>>
> >>> On Thu, 17 Sep 2009, Greg KH wrote:
> >>> >
> >>> > I think the udev version in older Fedora releases can't handle this
> >>> > kernel option, which is fine, just don't enable it. ??Newer versions can
> >>> > handle it, right?
> >>>
> >>> .. conversely, if you can't be bothered to set up /dev/null and /dev/zero
> >>> correctly, I would suggest that you not set them up AT ALL in devtmpfs.
> >>
> >> Fair enough.
> >>
> >>> The thing is, 0600 for those nodes is just _wrong_. Don't do it.
> >>
> >> Ok, Kay, care to just treat these as "special"?
> >
> > Sure, the patch I sent yesterday does that. We might want to drop the
> > USB device node permissions (same as the proc nodes), but they are
> > probably not needed?
> >
> > Ingo, do you possibly have a chance to test if your setup comes up 
> > with that? That would be great to know.
> 
> With that patch, I can login as a normal user without any udev ever 
> started, and no static content copied to /dev.

Great. Please merge this without waiting me to clear up any of my (way 
too much) backlog and get it tested. The only hickup i had was the 
/dev/zero & /dev/null permission stuff that prevented ssh logins. With 
that fixed i'm a happy camper.

Self-contained /dev is great, udev is a total PITA on older distros (on 
this box it sometimes takes 3 minutes for udev to boot ...) so turning 
on devtmpfs and getting something functional in exchange is a big 
selling point IMO.

Btw., i never understood the separation of udev from the kernel. It's 
not like it makes any sense without a Linux kernel - and the separation 
just increases release cycle pain and causes (unnecessary) detachment 
from the actual kernel. Should be hosted in tools/udev/ or so ;-)

	Ingo
