Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYA1PK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYA1PK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYA1PKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:10:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbYA1PKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:10:17 -0500
Date: Mon, 28 Jan 2008 16:09:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Jesse Barnes <jesse.barnes@intel.com>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
Message-ID: <20080128150957.GA12205@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com> <200801211209.23901.yinghai.lu@sun.com> <alpine.DEB.0.999999.0801211635480.6668@p34.internal.lan> <200801221950.06477.yinghai.lu@sun.com> <alpine.DEB.0.999999.0801251858450.4388@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.999999.0801251858450.4388@p34.internal.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Tried it, it worked successfully!
>
> With stock kernel, previous way I had to use it was mem=8832M and top 
> showed this:
>
> top - 18:53:52 up 1 min,  2 users,  load average: 1.03, 0.30, 0.10
> Tasks: 169 total,   1 running, 168 sleeping,   0 stopped,   0 zombie
> Cpu(s):  6.1%us,  2.6%sy,  4.5%ni, 81.3%id,  5.5%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   8039464k total,  1288948k used,  6750516k free,     3640k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   178528k cached
>
> With kernel you mentioned and use e820 v3:
>
> top - 18:48:13 up 3 min,  6 users,  load average: 1.67, 0.68, 0.25
> Tasks: 195 total,   2 running, 193 sleeping,   0 stopped,   0 zombie
> Cpu(s): 18.5%us,  1.2%sy,  1.6%ni, 74.8%id,  3.9%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   8037668k total,  1438732k used,  6598936k free,     6844k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   273928k cached
>
> No append mem= required.
>
> A full dmesg is attached so you can analyze the e820/MTRR mapping.

thanks for testing it! The code indeed successfully trimmed your memory 
map by 64MB:

from:

 [    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)

to:

 [    0.000000]   modified: 0000000100000000 - 0000000228000000 (usable)
 [    0.000000]   modified: 0000000228000000 - 000000022c000000 (reserved)

what happened on your box previously when you booted without any 
trimming - did it sometimes slow down or something like that?

	Ingo
