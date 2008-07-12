Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYGLO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYGLO4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 10:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGLO4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 10:56:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:57579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYGLO4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 10:56:05 -0400
Date: Sat, 12 Jul 2008 07:55:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
Message-ID: <20080712075532.13483b21@infradead.org>
In-Reply-To: <4878B4B5.5060007@gmail.com>
References: <20080710215039.2A143154218@magilla.localdomain>
	<20080711054605.GA17851@elte.hu>
	<alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org>
	<4878883F.10004@gmail.com>
	<4878B4B5.5060007@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 16:42:13 +0300
Török Edwin <edwintorok@gmail.com> wrote:

> On 2008-07-12 13:32, Török Edwin wrote:
> > I haven't yet tried ftrace on this box, and neither did I try
> > Roland's patch yet. I will try that now, and hopefuly come back
> > with some numbers shortly.
> >   
> 
> tip/master of today already includes Roland's patch, so I have tested
> it without even knowing on the 64-bit box.
> [After gathering all the traces, I wanted to repeat everything with
> the patch applied, but there was no need since its already there].
> I can say that I didn't notice any difference in the delays (I still
> get 24 - 30 second delays).
> I also tried Linus's readdir patch, the latency is around 27 seconds
> (was 30 before). I am not sure if it is an improvement, or measurement
> noise.
> 
> Also I wasn't able to reproduce the  'Ctrl+Z works faster than Ctrl+C'
> symptom, perhaps it is just a coincidence: by the time I press Ctrl+Z
> to interrupt, enough time has passed (30+ secs), that the same effect
> would have been obtained by another Ctrl+C, or by just waiting.
> 
> On 32-bit, I think the 2-3 seconds latency can be attributed to I/O
> delays, and I think its acceptable given the slow disk (5k4 rpm sata).

I see really bad delays on 32 bit as well, but they go away for me if I
do
echo 4096 > /sys/block/sda/queue/nr_requests



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
