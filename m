Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbYDAWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbYDAWOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYDAWOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:14:30 -0400
Received: from pat.uio.no ([129.240.10.15]:52432 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYDAWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:14:29 -0400
Subject: Re: regression: am-utils stopped working in 2.6.25-rc*
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <20080401210742.GE21343@fieldses.org>
References: <Pine.SOC.4.64.0803281447530.6128@math.ut.ee>
	 <20080401210742.GE21343@fieldses.org>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 18:14:23 -0400
Message-Id: <1207088063.13443.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 60036A6E869C83AE735611D98B6693100ED5B963
X-UiO-SR-test: 71E0BA4065EF9680826C78D8559867EBFA7C0219
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 92 total 7649059 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-01 at 17:07 -0400, J. Bruce Fields wrote:
> On Fri, Mar 28, 2008 at 03:20:18PM +0200, Meelis Roos wrote:
> > Current 2.6.25-rc* kernels have broken am-utils (NFS-based automounter) 
> > support. No error messages, just "no such file or directory" when trying 
> > to enter /net/anotherhostname. Just tried 2.6.24 and that worked fine. 
> > am-utils is the latest in Debian unstable, 6.1.5-9.
> > 
> > Earliest 2.6.25-rc currently tested was 2.6.25-rc3+git as of 20080304. 
> > This version reports 
> > Invalid hostname "pid3477@koiott:/net" in NFS lock request
> > into dmesg and am-utils does not work.
> > 
> > 2.6.25-rc4+git as of 20080310 and later ones do not show this message 
> > but am-utils does still not work.
> > 
> > Will try bisecting it further.
> 
> Have you figured out anything more?  Can strace show exactly which
> system call is  failing?

See the bugzilla report:
  http://bugzilla.kernel.org/show_bug.cgi?id=10349

I'm still waiting to hear back from Meelis, but to me this looks like an
am-utils bug.

AFAICS, am-utils advertises a binary NFS mount structure version of '6',
to the mount() syscall, but internally they only initialise the
equivalent of a version '4' structure.
When
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=f9c3a3802119a2d30f3e4a69aef30a81e09d0209
was merged, then this failure to initialise the selinux 'context' field
causes mount() to return an EINVAL.

Cheers
  Trond

