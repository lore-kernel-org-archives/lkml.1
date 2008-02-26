Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbYBZHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbYBZHZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYBZHZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:25:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356AbYBZHZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:25:07 -0500
Date: Tue, 26 Feb 2008 08:24:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: force re setting the mmconf for fam10h if
	acpi=off
Message-ID: <20080226072451.GD24820@elte.hu>
References: <200802251841.36135.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802251841.36135.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> some BIOS only let AMD fam 10h handle bus0, and nvidia mcp55/ck804 to 
> handle other buses. at that case MCFG will cover all over them.
> 
> but with acpi=off, we can not use MCFG. this patch will double check 
> the busnbits, and if it is less handling 256 bues, and acpi=off will 
> forcely reset the mmconf in msr, so we still use mmconf in above case.

thanks, applied.

> @@ -720,14 +720,21 @@ static void __cpuinit fam10h_check_enabl

btw., a cleanliness suggestion: wouldnt it be cleaner to separate all 
the extra AMD family 16 code into a separate file? That should make it 
more focused and more isolated as well.

	Ingo
