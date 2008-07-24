Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYGXTF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYGXTF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYGXTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:05:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:27403 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYGXTFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ipGCOo4ZYJwDbRWgu3LrxF3OqbuIwMwxni2im8rpFXucECXIzZpno+6ES28iG1Ba8s
         q0oPDN31N8EuL+KZ4aq7qH0hfjM1IBshsm6qYEZHX7K4MVKOxt4yHcfTE8HFU1vTX+9K
         4OnElwFQM2Rdo3Uj0/iYCKfR7U2DwBABdnpjE=
Message-ID: <19f34abd0807241205v78d32334w269c013d2bc2601d@mail.gmail.com>
Date: Thu, 24 Jul 2008 21:05:17 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: KGDB fails to pass selft tests on x86-64 (v2.6.26)
Cc: "Francis Moreau" <francis.moro@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <488897E4.8070806@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com>
	 <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com>
	 <488891F2.9020509@windriver.com>
	 <19f34abd0807240738h7ac5e716rcfa39d528b07870f@mail.gmail.com>
	 <488897E4.8070806@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 4:55 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> It is not likely that CONFIG_DEBUG_RODATA can have any impact because
> the boot test occurs before the text sections are marked read-only.  A
> hang in this section indicates a conflict where something is spinning
> for a lock in the NMI handler, or the NMI handler re-entered and tried
> to acquire another lock.
>
> In the 2.6.26 time frame I found and fixed at least one defect around
> updating the clock while in the NMI which required that you not do it
> from the NMI context.  It sounds as if there is yet another problem
> along these lines, and of course it is a timing race...

I just got another one now, with HEAD at
f0766440dda7ace8a43b030f75e2dcb82449fb85:

calling  init_kgdbts+0x0/0x20
kgdb: Registered I/O driver kgdbts.
kgdbts:RUN plant and detach test
kgdbts:RUN sw breakpoint test
kgdbts:RUN bad memory access test
kgdbts:RUN singlestep test 1000 iterations
kgdbts:RUN singlestep [0/1000]
kgdbts:RUN singlestep [100/1000]
kgdbts:RUN singlestep [200/1000]
kgdbts:RUN singlestep [300/1000]
kgdbts:RUN singlestep [400/1000]
kgdbts:RUN singlestep [500/1000]
kgdbts:RUN singlestep [600/1000]

Full stop. But the commit has timestamp May 9, 2008, so maybe you
fixed it after that.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
