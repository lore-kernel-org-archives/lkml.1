Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbZGIP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbZGIP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZGIP0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:26:14 -0400
Received: from thunk.org ([69.25.196.29]:46975 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZGIP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:26:13 -0400
Date: Thu, 9 Jul 2009 11:25:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, tridge@samba.org,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090709152541.GA6334@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
	Jan Engelhardt <jengelh@medozas.de>,
	Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
	john.lanza@linux.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
	jcm@jonmasters.org
References: <19028.3736.892828.352905@samba.org> <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <19028.31088.400461.939917@samba.org> <20090708130256.40957c3f@lxorguk.ukuu.org.uk> <19028.39145.180869.603673@samba.org> <20090708142510.5068b4c3@lxorguk.ukuu.org.uk> <19029.17896.769106.375379@samba.org> <20090709104228.7821e2f0@lxorguk.ukuu.org.uk> <1247147981.3898.15.camel@mulgrave.site> <20090709151009.07b2508b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709151009.07b2508b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 03:10:09PM +0100, Alan Cox wrote:
> > contributory infringement based on shipping the code.  I don't actually
> > believe that a compile time option they turn on in the binary kernel to
> > make it non infringing coupled with shipping code where the user could
> > recompile with it off is sufficient to rise to the tests under the
> > contributory infringement doctrine.
> 
> Its a simple risk test. Anything which reduces risk but does not change
> functionality is something you do. Its basically a zero cost way to
> reduce the chances of being shot at.

Look, even if what you say is valid (despite the advice of lawyers),
it is still useful for us to apply the patch (with the CONFIG option)
in the upstream sources.  It means that support for the workaround
stays in the mainstream sources, so we don't have to worry about
separate patch going no longer applying as time goes by and the
upstream sources change over time.  *If* a vendor really wants to
strip out the source code, they can do that easily enough using
unifdef to strip out the one specific CONFIG option.

However, I don't think they will think it's necessary, and I'll tell
you why.  Regardless of whether or not source code with an #ifdef'ed
out (but still present) source code might be considered "contributory
infringment" (and we have legal advice saying that this would not be
the case), either way, the *binary*, which is to say the **product**
does not contain any of the infringing functionality or code.  Hence,
the patent troll won't be able to use an ITC action to stop the
product at the border, thus putting the potentially weak company out
of business.  Suing for contributory infringment takes time;
potentially years, so there is plenty of time for (a) the patent
troll, if it is a company like Microsoft, to suffer all sorts of
public relations damange, thus revealing the claims of people like Sam
Ramji as empty and cynical, and (b) for the community to rally around
said company and provide defense.  In addition, healing a cliam of
contributory infringment is easy enough; simply releasing a version of
the source code with unifdef applied won't changing the resulting
binary.   

In any case, the fact that the patent troll won't be able to put a
company out of business, but instead might have to wage a long legal
war (consider how long the SCO lawsuits have dragged on), will tend to
dissuade the rational troll from pursuing such a path; and even if we
do have an irrational actor, (a) I don't really think Microsoft is
irrational, and (b) in the U.S. you can get a lawyer to sue a ham
sandwich, so there's no real proactive steps you can take to protect
yourself against an irrational actor who is bound and determined to
abuse the legal system; and most companies and lawyers (as opposed to
people who like to play lawyers on mailing lists and TV) understand
that.

But in any case, even for a very risk-averse company, getting this
proposed patch into mainline is useful, since at any point in time the
company can get a version of the code without any code that might be
claimable as being infringing by using unifdef.  So it's still a net
win.  And if people are worried about the very small chances of
problems (which perhaps we can improve), we can fix that as future
patches against the mainline --- which is the right way to do OSS
development.  Given that Hirofumi-san has already decided to take this
patch, so unless Linus decides to override his decision, this
discussion is rapidly becoming moot in any case.

Regards,

						- Ted
