Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYAYLJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYAYLJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYAYLJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:09:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYAYLJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:09:49 -0500
Date: Fri, 25 Jan 2008 12:09:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
Message-ID: <20080125110935.GA20026@elte.hu>
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801250042.53074.yinghai.lu@sun.com>
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

> [PATCH] x86: trim ram need to check if mtrr is there v3

> > H. Peter Anvin wrote:
> > Looks like the code doesn't check that the CPU *has* MTRRs...
> 
> so more strict check if mtrr is there really.
> bail out if mtrr all blank when qemu cpu model is used
> 
> and check if is AMD as early
> also remove 4G less check, according to hpa.

thanks, applied. Shouldnt we put in an exception for when there is MTRR 
support, but they dont cover anything. Still emit a warning - but 
booting up real slow is still better than losing all of RAM and crashing 
...

i also updated the messages, they now go like this:

  WARNING: strange, CPU MTRRs all blank?

and:

  WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 45MB of RAM.

	Ingo
