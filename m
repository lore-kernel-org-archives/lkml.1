Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYHVU5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYHVU5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHVU5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:57:31 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:49707 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYHVU5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:57:30 -0400
Date: Fri, 22 Aug 2008 17:57:41 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822175741.6bc83dc8@doriath.conectiva>
In-Reply-To: <20080822142054.403cbdef@doriath.conectiva>
References: <20080820162925.75a5e064@doriath.conectiva>
	<48ADDF4F.2020401@zytor.com>
	<48AE5FCF.6030103@zytor.com>
	<20080822065012.GV14110@elte.hu>
	<20080822113941.147a1db0@doriath.conectiva>
	<20080822153451.GA8390@Krystal>
	<20080822132948.57e47076@doriath.conectiva>
	<20080822163520.GA9860@Krystal>
	<20080822142054.403cbdef@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 22 Aug 2008 14:20:54 -0300
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> escreveu:

| Em Fri, 22 Aug 2008 12:35:20 -0400
| Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
| 
| | * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
| | > Em Fri, 22 Aug 2008 11:34:52 -0400
| | > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
| | > 
| | > | * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
| | > | > Em Fri, 22 Aug 2008 08:50:12 +0200
| | > | > Ingo Molnar <mingo@elte.hu> escreveu:
| | > | > 
| | > | > | 
| | > | > | * H. Peter Anvin <hpa@zytor.com> wrote:
| | > | > | 
| | > | > | > H. Peter Anvin wrote:
| | > | > | >>>
| | > | > | >>>  Does this look like a kernel bug?
| | > | > | >>>
| | > | > | >>
| | > | > | >> No, it looks like a very common virtualizer bug.  Does the attached  
| | > | > | >> patch work for you?
| | > | > | >>
| | > | > | >
| | > | > | > Also, in addition to this, please try tip:master.  There is a patch in 
| | > | > | > tip:master which I hope should fix this problem, but the details are 
| | > | > | > important.
| | > | > | 
| | > | > | access coordinates would be at:
| | > | > | 
| | > | > |   http://people.redhat.com/mingo/tip.git/README
| | > | > 
| | > | >  As I already have Linus tree downloaded I have cloned it in
| | > | > the usual way.
| | > | > 
| | > | >  Got the same results: OOPS in virtualbox but it works on QEMU.
| | > | > 
| | > | >  The OOPS's output follows and I have attached the .config I'm using
| | > | > to reproduce the problem.
| | > | > 
| | > | 
| | > | Can you try booting with the kernel argument :
| | > |   debug_alternative 
| | > | 
| | > | The dmesg of the kernel bootup up to the oops would be helpful.
| | > | 
| | > | My guess is that there may be something wrong with irq disabling which
| | > | protects text_poke_early in apply_alternatives().
| | > 
| | >  I have attached two files:
| | > 
| | >   - normal.txt: normal boot with no debug options
| | >   - debug-alternative.txt ignore_loglevel and debug-alternative boot
| | >     options
| | > 
| | >  I had to pass ignore_loglevel otherwise it wouldn't print
| | > anything.
| | > 
| | 
| | Ok, now can you try booting with either of those args :
| | 
| | noreplace-paravirt
| | noreplace-smp
| | 
| | And see which one(s) works ?
| 
|  noreplace-paravirt works, the other one causes no change.

 I have asked Mandriva and Ubuntu users to test this and all of
them so far are saying that noreplace-paravirt works.

 It makes the system slower, but it works.

-- 
Luiz Fernando N. Capitulino
