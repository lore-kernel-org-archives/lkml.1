Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXKSU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXKSU4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXKSU4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:56:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbXKSU4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:56:10 -0500
Date: Mon, 19 Nov 2007 21:55:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071119205555.GA28696@elte.hu>
References: <20071119203152.GA1772@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119203152.GA1772@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> On unloaded x60 system, 2.6.24-rc3 (tainted-pavel-so if someone can
> reproduce it, it would be helpful):
> 
> pavel@amd:~$ while true; do time sleep 0.01; done
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 30.71%CPU
> 0.00user 0.00system 0.02 (0m0.024s) elapsed 8.36%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.53%CPU
> 0.00user 0.00system 0.02 (0m0.026s) elapsed 7.75%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.34%CPU
> 0.00user 0.00system 0.20 (0m0.207s) elapsed 1.45%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.59%CPU
> 0.00user 0.00system 0.23 (0m0.230s) elapsed 1.30%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.61%CPU
> 0.00user 0.00system 0.20 (0m0.201s) elapsed 1.48%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 15.50%CPU
> 0.00user 0.00system 0.19 (0m0.190s) elapsed 1.05%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.37%CPU
> 0.00user 0.00system 0.04 (0m0.049s) elapsed 4.09%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.35%CPU
> 0.00user 0.00system 0.01 (0m0.017s) elapsed 11.89%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.38%CPU
> 0.00user 0.00system 0.08 (0m0.081s) elapsed 3.71%CPU
> 0.00user 0.00system 0.01 (0m0.013s) elapsed 23.33%CPU
> 0.00user 0.00system 0.01 (0m0.019s) elapsed 15.92%CPU
> 
> nohz=off helps a lot. while true; do time sleep 0.0; done does not 
> have unexpected latencies.

does hpet=disable on the boot line also help? (without nohz=off)

	Ingo
