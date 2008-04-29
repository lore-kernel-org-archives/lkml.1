Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYD2KcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYD2KcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYD2KcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:32:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbYD2KcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:32:08 -0400
Date: Tue, 29 Apr 2008 12:31:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gabriel C <nix.or.die@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Message-ID: <20080429103150.GJ23198@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com> <20080122165125.GA17992@elte.hu> <200801221623.20861.yinghai.lu@sun.com> <20080426035614.a30afb17.akpm@linux-foundation.org> <48132665.8050202@googlemail.com> <86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com> <m17ieh4zuo.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17ieh4zuo.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> So lets concentrate on PAT to solve contiguous MTRR region problems.
> 
> We can upgrade UC to WC with pat.  As well as demote WB to UC or WC. 
> So for those regions we know about we should be in good shape.

sure, but whatever we do now in the sysfs API space, it will hit distros 
only in a year, relistically, because Xorg also has to adopt to it. The 
workaround from Yinghai looks reasonably configurable - if we mess up 
(say an SMM comes in while we fiddle with the MTRRs) we'll likely get a 
lockup right then, during bootup, so it wont be hard to realize what 
went wrong. In that sense it's in fact safer to do it during early init 
than let the user do it via some script, because the window is smaller, 
etc.

we still default to the safe mode of course and dont touch MTRRs, but 
for note the various configuration options that are available to distros 
and users.

	Ingo
