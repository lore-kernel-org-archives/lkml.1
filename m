Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYKDR3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYKDR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYKDR33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:29:29 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47708 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbYKDR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:29:28 -0500
Message-Id: <1225819765.13069.1282952549@webmail.messagingengine.com>
X-Sasl-Enc: oK9Db5hSai7MXWiroXWUif7wDkK2bRaknXZtQjSEVK+n 1225819765
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andi Kleen" <andi@firstfloor.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu>
 <1225805399.25337.1282903253@webmail.messagingengine.com>
 <20081104140030.GA16178@elte.hu>
 <1225815789.30706.1282936457@webmail.messagingengine.com>
 <20081104164717.GD21470@localhost> <20081104165811.GA1664@elte.hu>
 <20081104171346.GF21470@localhost>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081104171346.GF21470@localhost>
Date: Tue, 04 Nov 2008 18:29:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Nov 2008 20:13:46 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> [Ingo Molnar - Tue, Nov 04, 2008 at 05:58:11PM +0100]
> | 
> | * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | 
> | > [Alexander van Heukelum - Tue, Nov 04, 2008 at 05:23:09PM +0100]
> | > ...
> | > | 
> | > | I did some timings using the little program below (32-bit only),
> doing
> | > | 1024 times the same sequence. TEST1 is just pushing a constant onto
> | > | the stack; TEST2 is pushing the cs register; TEST3 is the sequence
> | > | from the patch to extract the vector number from the cs register.
> | > | 
> | > | Opteron    (cycles): 1024 / 1157 / 3527
> | > | Xeon E5345 (cycles): 1092 / 1085 / 6622
> | > | Athlon XP  (cycles): 1028 / 1166 / 5192
> | > 
> | > Xeon is defenitely out of luck :-)
> | 
> | it's still OK - i.e. no outrageous showstopper overhead anywhere in 
> | that instruction sequence. The total round-trip overhead is what will 
> | matter most.
> | 
> | 	Ingo
> | 
> 
> Don't get me wrong please, I really like what Alexander have done!
> But frankly six time slower is a bit scarying me.

Thanks again ;). Now it _is_ six times slower to do this tiny
piece of code... But please keep in mind all the activity that
follows to save the current data segment registers (the stack
segment and code segment are saved automatically), the general
purpose registers and to load most of the data segments with
kernel-space values. And looking at it now... do_IRQ is also
not exactly trivial.

Also, I kept the information that is saved on the stack
exactly the same. If this is not a requirement, "push %cs"
is what is left of this expensive (6 cycle!) sequence.
Even that could be unnecessary if the stack layout can
be changed... But I'ld like to consider that separately.

Greetings,
    Alexander

> 		- Cyrill -
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

