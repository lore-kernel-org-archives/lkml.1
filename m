Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0BEH5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:57:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39713 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644Ab0BEH5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:57:10 -0500
Date: Fri, 5 Feb 2010 08:56:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100205075645.GF9320@elte.hu>
References: <20100204181218.GA6175@elte.hu>
 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
 <20100204193232.GD6665@elte.hu>
 <20100204115316.69beee75@jbarnes-piketon>
 <20100204202254.GA24716@elte.hu>
 <20100204204829.GA24608@srcf.ucam.org>
 <20100204210559.GC19050@elte.hu>
 <20100204210950.GA25295@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204210950.GA25295@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Feb 04, 2010 at 10:05:59PM +0100, Ingo Molnar wrote:
> 
> > Regressions are not limited to 'same config' kernels, last i checked. If that 
> > has changed (or if i'm misunderstanding it) then it would be nice to hear a 
> > clarification about that from Linus.
> 
> If an option has *never* worked on a given configuration, then it's not a 
> regression. [...]

The *main driver* (CONFIG_DRM_RADEON=y, as far as the user is concerned) is 
many years old and it certainly worked just fine for tens of thousands of 
test iterations on this box, up until that commit.

That box alone has done in excess of half a million boot iterations in the 
past 2+ years. About 28% of the tests had CONFIG_DRM_RADEON=y, so the number 
of successful bootups with CONFIG_DRM_RADEON=y is in excess of one hundred 
thousand. There was not a single failed bootup in those two years due to the 
CONFIG_DRM_RADEON driver that i can remember.

If it now does not boot up if all its sub-options are enabled, even of some 
of those sub-options are new, does that count as a driver regression? Sure it 
does to me ...

IMHO you are trying to put a narrow technical distinction into it which does 
not exist for users. You argue that it's a new default-off sub-option of an 
existing driver, hence it cannot be a regression. The option shows up as a 
sub-option to an existing driver in make oldconfig, with a fairly innocious 
sounding help text, so to a user it certainly looks as if it's one unit and 
that it is the radeon driver that regressed.

*If* we make a driver feature available in a popular driver and make it 
Kconfig visible without obvious warnings (i.e. lure the user to enable it 
with the notion that it's just one coherent unit with a trusted, existing 
driver), we should also hold up the other side of the deal and treat the 
*bugs* as a coherent unit as well.

I.e. treat the driver as a coherent whole not only when it's convenient to 
us, but also when it's somewhat inconvenient to do. We cannot have it both 
ways.

	Ingo
