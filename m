Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYKDSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYKDSof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYKDSoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:44:20 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41640 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428AbYKDSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:44:17 -0500
Message-Id: <1225824256.28612.1282966677@webmail.messagingengine.com>
X-Sasl-Enc: Gm6kM3pqBIHO0plR4phqp6/4ZIyxvRUUPfop8iURd1lo 1225824256
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com>
 <20081104150729.GC21470@localhost>
 <20081104170501.GE29626@one.firstfloor.org>
 <1225822006.21441.1282961299@webmail.messagingengine.com>
 <491090F3.5020701@zytor.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <491090F3.5020701@zytor.com>
Date: Tue, 04 Nov 2008 19:44:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 04 Nov 2008 10:14:11 -0800, "H. Peter Anvin" <hpa@zytor.com>
said:
> Alexander van Heukelum wrote:
> > 
> > That's good to know. I assume this LOCKed bus cycle only occurs
> > if the (hidden) segment information is not cached in some way?
> > How many segments are typically cached? In particular, does it
> > optimize switching between two segments?
> > 
> 
> Yes, there is a segment descriptor cache (as opposed to the hidden but
> architectural segment descriptor *registers*, which the Intel
> documentation confusingly call a "cache".)
> 
> It is used to optimize switching between a small number of segments, and
> was crucial for decent performance on Win9x, which contained a bunch of
> 16-bit code.

Thanks for the info!

This just means that if there are performance problems, the
'specialized'
handlers should be using the kernel segment or maybe a single common
segment. It would still allow us to get rid of the trampolines. A stack
trace should be enough to reconstruct which vector was originally called
in that case. Only the common_interrupt-codepath needs the original
vector as far as I can see.

You just made testing on larger machines with a lot of external
interrupts necessary :-/. (Assuming small machines do not show
performance problems, that is.)

Greetings,
    Alexander

> 	-hpa
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

