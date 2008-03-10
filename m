Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYCJWR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYCJWR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYCJWQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:16:58 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:34691 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYCJWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:16:56 -0400
From: Chr <chunkeey@web.de>
To: linux-kernel@vger.kernel.org
Subject: endless loop in native_flush_tlb_others in smp_64.c
Date: Mon, 10 Mar 2008 23:16:54 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102316.54457.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19mgCBaSt8674GjThOpQn7cuuRk5g8DdeJGencE
	Lq//55n00zricwTYzu7M7hrgrva2qIXTLgA+aEmQvQydzC7xOy
	zyxQVOuqc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ever since I moved to 2.6.25-rcY (Y should be between 2 and 5!). 
I've seen several, but really hard-to-catch instant freezes on my 
AMD64 Athlon X2 4200+ system... 

Most of them happend in X.org so at first I thought it had something to do 
with the NVIDIA module... BUT, one time it froze "a way before" the module 
could get loaded (and desynced my raid.......). 

---
SYSRQ-P revealed that the CPU were looping inside:

smp_64.c native_flush_tlb_others:
assembler code:
< 1ee:   f3 90                   pause
< 1f0:   f6 45 00 03             testb  $0x3,0x0(%rbp)
< 1f4:   75 f8                   jne    1ee <native_flush_tlb_others+0x5f>

also known as: (in C)

while (!cpus_empty(f->flush_cpumask))
	cpu_relax();

So... has anyone a good idea what's happening here exactly? Or is there 
already another topic or even a patch available?

Regards,
	Chr.
