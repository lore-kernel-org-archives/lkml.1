Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYH1Nal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYH1Nal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYH1Nad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:30:33 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:54482 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYH1Nac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:30:32 -0400
Date: Thu, 28 Aug 2008 10:30:13 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Gerhard Brauer <gerhard.brauer@web.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080828103013.163730ee@doriath.conectiva>
In-Reply-To: <20080827233328.GC25531@Krystal>
References: <20080822175741.6bc83dc8@doriath.conectiva>
	<48AF2ABD.9070100@zytor.com>
	<20080826141851.GA5300@tux1.brauer.lan>
	<20080826145338.GA8601@Krystal>
	<20080826131354.356ae11d@doriath.conectiva>
	<20080826171822.GB14906@Krystal>
	<20080826150222.0cf1542c@doriath.conectiva>
	<20080826181558.GA16887@Krystal>
	<20080826203449.GD5300@tux1.brauer.lan>
	<20080827161346.35b48d75@doriath.conectiva>
	<20080827233328.GC25531@Krystal>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 27 Aug 2008 19:33:28 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:

| * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
| > Em Tue, 26 Aug 2008 22:34:49 +0200
| > Gerhard Brauer <gerhard.brauer@web.de> escreveu:
| > 
| > | On Tue, Aug 26, 2008 at 02:15:58PM -0400, Mathieu Desnoyers wrote:
| > | > 
| > | > Ok, it might still be caused by paravirt and alternatives instruction
| > | > patching. What if you also do :
| > | > 
| > | > alternative_instructions()
| > | > 
| > | > +        unsigned long flags;
| > | >         /* The patching is not fully atomic, so try to avoid local interruptions
| > | >            that might execute the to be patched code.
| > | >            Other CPUs are not running. */
| > | >         stop_nmi();
| > | > #ifdef CONFIG_X86_MCE
| > | >         stop_mce();
| > | > #endif
| > | > +        local_irq_save(flags);
| > | > 
| > | > 
| > | > ...
| > | > +        local_irq_restore(flags);
| > | >         restart_nmi();
| > | > #ifdef CONFIG_X86_MCE
| > | >         restart_mce();
| > | > #endif
| > | > 
| > | > ?
| > | 
| > | Hej! This last changes (in addition to the others you mentioned) seems
| > | to be a good shot. I could reboot 8 times the guest, compile several
| > | packages (something which always leeds to the oops) and currently i
| > | build two big packages simultan. So this is heavy IO.
| > 
| >  Yeah, it works for me too and it's good to know that you are doing
| > additional tests. I'm doing only boot tests... I was testing lots of
| > kernels and doing additional tests would take a lot of time.
| > 
| >  Now, what does this mean? Is VirtualBox issuing interrupts when it
| > shouldn't or should this section of the code be better protected?
| > 
| 
| Since this problem appears while we are using a simple memcpy (the
| text_poke_early version), but disappears when we disable interrupts for
| a longer period of this, I suspect a problem with irq disabling in
| Virtualbox.
| 
| We could try to add some nsleep() or msleep() calls within text_poke and
| text_poke_early before and after the code modificatoin to see if the
| problem disappears. If it does, then that would somewhat confirm the
| racy irq disable thesis.

 Well, a Ubuntu kernel guy has reported in the virtualbox's ticket[1]
that the oops doesn't happen if he puts a printk() in the crash site.

 The funny thing is that someone (who might be a virtualbox developer)
used the same race argument to say that this is a bug in the kernel.

 What concerns me though is that how can virtualbox be worth using
in the Linux community if it's probably not working for various distros
(currently Fedora, Ubuntu, Mandriva and ArchLinux).

 Thanks for the effort, guys.

[1] http://www.virtualbox.org/ticket/1875

-- 
Luiz Fernando N. Capitulino
