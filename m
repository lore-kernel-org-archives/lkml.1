Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYAGLTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYAGLTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYAGLTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:19:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbYAGLTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:19:40 -0500
Date: Mon, 7 Jan 2008 12:19:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jplatte@naasa.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Message-ID: <20080107111930.GB29973@elte.hu>
References: <200801071151.11200.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801071151.11200.lists@naasa.net>
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


* Joerg Platte <lists@naasa.net> wrote:

> Hi,
> 
> when booting kernel 2.6.24-rc{4,5,6,7} top reports up to 100% iowait, 
> even if no program accesses the disc on my Thinkpad T40p. Kernel 
> 2.6.23.12 does not suffer from this. Is there anything I can do to 
> find out which process or which part of the kernel is responsible for 
> this? I can try to bisect it, but maybe there are other possibilities 
> to debug this, since I cannot boot this computer frequently. I 
> discovered, that there is no iowait within the first few seconds after 
> waking up from suspend to ram...

do:

  echo t > /proc/sysrq-trigger

and send us the dmesg output. If the dmesg output does not include the 
bootup bits then increase CONFIG_LOG_BUF_SHIFT to 20 or so:

  CONFIG_LOG_BUF_SHIFT=20

to have a large enough kernel messages buffer.

	Ingo
