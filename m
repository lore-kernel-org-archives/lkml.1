Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYFAQrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYFAQrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYFAQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:47:41 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:35675 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYFAQrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:47:41 -0400
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Date: Sun, 1 Jun 2008 18:47:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, arjan@linux.intel.com
References: <200806011101.06491.j.mell@t-online.de> <87wsl9fkno.fsf@basil.nowhere.org>
In-Reply-To: <87wsl9fkno.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806011847.29744.j.mell@t-online.de>
X-ID: bNhgY4ZQghGtoBmx0htpocvu8jphlRdFvmBnxebXLrLw432PN0Q-QAjy1KY6-HBQIP
X-TOI-MSGID: d4a3271c-800d-468e-8931-6b3fb0a77d8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag, 1. Juni 2008, Andi Kleen wrote:
> j.mell@t-online.de writes:
> > or it is restored more than
> > once. Please keep in mind, that I am always running two Einstein
> > processes simultaneously on my two cores!
> > I am willing to do further testing of this problem if someone can give
> > me a hint how to continue.
>
> My bet would have been actually on
> aa283f49276e7d840a40fb01eee6de97eaa7e012 because it does some nasty
> things (enable interrupts in the middle of __switch_to).
>
> I looked through the old patchkit and couldn't find any specific
> PREEMPT problems. All code it changes should run with preempt_off
>
> You could verify with sticking WARN_ON_ONCE(preemptible()) into
> all the places acc207616a91a413a50fdd8847a747c4a7324167
> changes (__unlazy_fpu, math_state_restore) and see if that triggers
> anywhere.

No, that did not trigger. I put the WARN_ON_ONCE into process.c, traps.c 
and also into the __unlazy_fpu macro in i387.h but I got no messages 
anywhere (dmesg, /var/log/messages, /var/log/warn) when the trap #8 
occurred. 
Meanwhile I am also running the tests on another machine to make sure it is 
not a hardware-related problem.

Any new ideas are welcome!

Meanwhile I will go back to 2.6.20 and revert
aa283f49276e7d840a40fb01eee6de97eaa7e012. Maybe I got on a wrong track...

Bye, 
         Jürgen
