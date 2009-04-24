Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZDXGh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZDXGh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZDXGhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:37:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57652 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZDXGhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:37:45 -0400
Date: Fri, 24 Apr 2009 08:37:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ACPI/hpet: prevent boot hang when hpet=force used on
	ICH-4M
Message-ID: <20090424063734.GA21739@elte.hu>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain> <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Linux tells ICH4 users that they can (manually) invoke
> "hpet=force" to enable the undocumented ICH-4M HPET.
> The HPET becomes available for both clocksource and clockevents.
> 
> But as of ff69f2bba67bd45514923aaedbf40fe351787c59
> (acpi: fix of pmtimer overflow that make Cx states time incorrect)
> the HPET may be used via clocksource for idle accounting, and
> hpet=force on an ICH4 box hangs boot.
> 
> It turns out that touching the MMIO HPET withing
> the ARB_DIS part of C3 will hang the hardware.
> 
> The fix is to simply move the timer access outside
> the ARB_DIS region.  This is a no-op on modern hardware
> because ARB_DIS is no longer used.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13087

Nice fix! This moots the other half-quirk patch you wrote for hpet, 
right?

	Ingo
