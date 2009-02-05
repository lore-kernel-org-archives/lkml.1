Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbZBETrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbZBETrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbZBETgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:36:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761564AbZBETgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:36:36 -0500
Date: Thu, 5 Feb 2009 20:36:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, samr <sam@ravnborg.org>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090205193619.GB31839@elte.hu>
References: <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu> <1233809147.13118.8.camel@gaiman> <498B1F2A.70209@oracle.com> <20090205191234.GG20470@elte.hu> <498B3A8F.3040801@oracle.com> <20090205192059.GB27422@elte.hu> <498B3CB8.3020202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B3CB8.3020202@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > kconfig was not broken at all in this case. It detected a circular 
> > dependency and did its work well.
> 
> Maybe.  I haven't seen an explanation for the problems that Eric reported 
> 2+ weeks ago.

The thing he reported 2 weeks ago is a straightforward recursive dependency 
bug in the config entries:

  drivers/gpu/drm/Kconfig:8:error: found recursive dependency:
   DRM -> <choice> -> DRM_I915 -> FB -> FB_I810 -> AGP -> DRM

this is the precise circular dependency problem that the I810_FB and 
INTEL_FB changes in my patch solve.

Give my patch a try :-)

	Ingo
