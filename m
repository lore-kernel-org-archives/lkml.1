Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYJWIG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYJWIG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJWIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:06:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38492 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYJWIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:06:10 -0400
Date: Thu, 23 Oct 2008 10:05:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081023080553.GB14714@elte.hu>
References: <20081022093615.GF12453@elte.hu> <1224746087-13991-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224746087-13991-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Keith Packard <keithp@keithp.com> wrote:

> > okay. So ... mind sending your io_mapping patch as a generic 
> > facility? It looks all good to me in its present form, except that 
> > it should live in include/linux/io.h, not in the 
> > drivers/gpu/drm/i915/io_reserve.h file
> > :-)
> 
> The first patch in this series (assuming I'm driving git-send-email 
> correctly) adds the io_mapping API. I ended up creating a new 
> linux/io_mapping.h file as the kernel init code uses io.h and got very 
> angry when I tried to include linux/highmem.h from that. I'm afraid I 
> gave up at that point and just moved the code to a new file.

ah ... good call, i missed that mess. linux/io.h is indeed dependency 
laden and it's best to keep new facilities separated anyway.

> The second patch switches the drm/i915 driver to the new API. 
> Performance improvements on 64-bit kernels are impressive as we were 
> using the slow path before and now get to take advantage of 64-bit 
> wonderfulness.

heh, cool - the wonders of 64-bit x86 :-)

Any ballpark-figure numbers you can share with us?

	Ingo
