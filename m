Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbYLPTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbYLPTjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbYLPTiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:38:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbYLPTiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:38:54 -0500
Date: Tue, 16 Dec 2008 20:38:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Janne Kulmala <janne.t.kulmala@tut.fi>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: x86: Fix HPET for Fujitsu u9200
Message-ID: <20081216193843.GD843@elte.hu>
References: <4947938D.3010004@tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947938D.3010004@tut.fi>
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


* Janne Kulmala <janne.t.kulmala@tut.fi> wrote:

> HPET timer is listed in the ACPI table, but needs a quirk entry in order 
> to work. Unfortunately, the quirk code runs after first HPET 
> hpet_enable() which has already determined that the timer doesn't work 
> (reads 0xFFFFFFFF). This patch allows hpet_enable() to be called again 
> after running the quirk code.
>
> Signed-off-by: Janne Kulmala <janne.t.kulmala@tut.fi>

applied to tip/timers/hpet, thanks Janne!

Venki, is this new hpet force-enable quirk entry generally OK:

 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_1,
                         ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_4,
+                        ich_force_enable_hpet);

i guess it's OK since we enable hpet on ICH8_1 already. Should we perhaps 
convert these quirks somehow to some ">= threshold_version" condition, 
instead of having to enumerate everything?

	Ingo
