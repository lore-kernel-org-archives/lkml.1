Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbZJLNHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbZJLNHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZJLNHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:07:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34297 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbZJLNHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:07:39 -0400
Date: Mon, 12 Oct 2009 15:06:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Message-ID: <20091012130652.GB25464@elte.hu>
References: <1255012399.4187.24.camel@mulgrave.site> <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain> <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain> <1255031298.4187.260.camel@mulgrave.site> <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain> <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain> <20091008210737.GD29181@mit.edu> <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain> <20091009091538.GA4154@elte.hu> <1255097287.2934.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255097287.2934.21.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@suse.de> wrote:

> On Fri, 2009-10-09 at 11:15 +0200, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Thu, 8 Oct 2009, Theodore Tso wrote:
> > > > 
> > > > So would it be acceptable to merge the 50 kloc of crap _during_ the
> > > > merge window?
> > > 
> > > Yes. I actually looked at the driver (since I had pulled it - I've 
> > > unpulled it but am still mulling it over), and while I think it looked 
> > > huge and overly complex, it by no means gave me the kinds of vibes I 
> > > get from some "obviously-ported-from-windows-with-no-clue" drivers.
> > > 
> > > So at least from my quick look I didn't get the feeling that the 
> > > driver was "evil". For me, it's a timing issue.  I hate getting big 
> > > pull requests after -rc1 is out, and I really don't like the feeling 
> > > that people are just ignoring the merge window.
> > > 
> > > That said, if somebody wants to look more closely at the driver, and 
> > > then wants to convince people that it should have gone through 
> > > "staging", feel free. But that's not what I've personally been arguing 
> > > about.
> > 
> > Greg, what's your take on the quality of this new driver? Do you have 
> > some time to do a review of this with drivers/staging/ versus drivers/ 
> > glasses on? The Git URI is at:
> 
> To me, the matter of staging versus actual tree isn't a quality issue 
> (otherwise we'd be shifting ~75% of SCSI drivers to staging, depending 
> on whose view of "quality" was being used). [...]

I think you need to update your notion of what goes into 
drivers/staging/ - these days it's primarily about code/implementation 
quality (Greg please correct me if i'm wrong about that).

Driver ABIs are distinctly down the priority list.

> [...] It's an ABI issue.  If we would have to change the user visible 
> ABI while the driver was being cleaned up, I'd want it in staging to 
> warn users to expect these problems.  Although we couldn't clean up 
> everything, I did make sure this driver plugs correctly into the 
> standard linux FC ABI before putting it in the SCSI tree, so there are 
> no ABI changes anticipated even though there will likely be a lot of 
> code changes.  Therefore, the correct clean up path for this one is 
> through the SCSI tree.

What kind of significant ABI does this driver expose? If this question 
even comes up then it's using the wrong kind of ABI i think. Drivers 
should almost never expose significant new ABIs.

If it's a storage management ABI then that should have been done at a 
higher level - possibly as a system call, but at minimum as a general 
facility.

(Anyway ... this cannot be argued without knowing what specific ABI you 
mean here.)

	Ingo
