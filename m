Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXC1MU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXC1MU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXC1MU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:20:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXC1MU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:20:27 -0400
Date: Wed, 28 Mar 2007 14:19:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas@m3y3r.de>, Frederic Riss <frederic.riss@gmail.com>,
       Marcus Better <marcus@better.se>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
Message-ID: <20070328121958.GA11290@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015949.GB16477@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070327015949.GB16477@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : second suspend to disk in a row results in an oops  (MSI)
> References : http://lkml.org/lkml/2007/3/17/43
>              http://lkml.org/lkml/2007/3/22/150
>              http://lkml.org/lkml/2007/3/26/205
>              http://lkml.org/lkml/2007/3/26/76
> Submitter  : Thomas Meyer <thomas@m3y3r.de>
>              Frédéric Riss <frederic.riss@gmail.com>
>              Marcus Better <marcus@better.se>
> Handled-By : Eric W. Biederman <ebiederm@xmission.com>
> Patch      : http://lkml.org/lkml/2007/3/24/136
> Status     : patch was suggested

i can reproduce a crash on the second suspend-to-ram, on a T60. I get a 
crash here:

 #ifdef CONFIG_PM
 static void __pci_restore_msi_state(struct pci_dev *dev)
 {
         int pos;
         u16 control;
         struct msi_desc *entry;

         if (!dev->msi_enabled)
                 return;

         entry = get_irq_msi(dev->irq);
         pos = entry->msi_attrib.pos; <-------- crash on NULL dereference


i.e. 'entry' is NULL after get_irq_msi(). (i can see the crash only on 
the VGA screen so no dump of it available. Can write down more info if  
it's helpful.)

I have tried Eric's patch above but now i always get a hang after 
"system 00:00: resuming", already upon the first suspend-resume. Not 
even the NMI watchdog can get the system out of that hang.

	Ingo
