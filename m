Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYAVQG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYAVQG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYAVQGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:06:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbYAVQGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:06:19 -0500
Date: Tue, 22 Jan 2008 17:05:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Rescheduling interrupts
Message-ID: <20080122160557.GA31831@elte.hu>
References: <200801220119.42312.caglar@pardus.org.tr> <200801221455.16814.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu> <200801221755.56470.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801221755.56470.caglar@pardus.org.tr>
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> > My theory is that for whatever reason we get "repeat" IPIs: multiple 
> > reschedule IPIs although the other CPU only initiated one.
> 
> Ok, please see http://cekirdek.pardus.org.tr/~caglar/dmesg.3rd :)

hm, the IPI sending and receiving is nicely paired up:

[  625.795008] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
[  625.795223] IPI (@native_smp_send_reschedule) from task amarokapp:2882 on CPU#1:

amarokapp does wake up threads every 20 microseconds - that could 
explain it. It's probably Xorg running on one core, amarokapp on the 
other core. That's already 100 reschedules/sec.

	Ingo
