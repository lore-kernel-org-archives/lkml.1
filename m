Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYJMUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYJMUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYJMUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:46:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53489 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbYJMUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:46:06 -0400
X-Sasl-enc: Cta7toJsjR5urSnjEFkj81za/jAEQ39quAqdGHsVR58R 1223930762
Date: Mon, 13 Oct 2008 17:45:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/18] net/rfkill/rfkill-input.c needs <linux/sched.h>
Message-ID: <20081013204559.GC28597@khazad-dum.debian.net>
References: <20081013195846.674654386@mail.of.borg> <20081013195922.392078574@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013195922.392078574@mail.of.borg>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> For some m68k configs, I get:
> 
> | net/rfkill/rfkill-input.c: In function 'rfkill_start':
> | net/rfkill/rfkill-input.c:208: error: dereferencing pointer to incomplete type
> 
> As the incomplete type is `struct task_struct', including <linux/sched.h> fixes
> it.

Line 208 is this (in latest Linus mainline and also v2.6.27):

spin_unlock_irq(&handle->dev->event_lock);

So we need to include sched.h to everything that uses spin_unlock_irq?  If
only some variants of m68k need that, shouldn't it have been added on the
header that defines spin_unlock_irq() on those arches, instead?

Or am I looking at a different version of rfkill-input.c than what you based
that error message on?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
