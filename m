Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbXHEI76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbXHEI76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 04:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXHEI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 04:59:51 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:16609 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXHEI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 04:59:50 -0400
From: Axel Reinhold <axel@freakout.de>
Message-Id: <200708050856.l758u4ou031651@bongo.freakout.de>
Subject: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
To: linux-kernel@vger.kernel.org
Date: Sun, 5 Aug 2007 10:56:04 +0200 (CEST)
X-Mailer: ELM [version 2.4ME+ PL123f (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="US-ASCII"
X-Logged: Logged by bongo.freakout.de as l758u4ou031651 at Sun Aug  5 10:56:05 2007
X-RZG-AUTH: lUESeo99iNzPSoEmsz8hSOHHL4mD896CIlAzdW8M7hBAattaCEr5VbOvKg==
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i found a bug in linux-2.4.35.

the bug produces a crashing kernel when compiled
with gcc >=4.2.0 and VIA C3 optimized -march=c3
(CONFIG_MCYRIXIII=y)

this issue was first discussed on the gcc bugzilla:
 http://gcc.gnu.org/bugzilla/show_bug.cgi?id=32264

and tracked down to the include/asm-i386/hw_irq.h
module with the help of the gcc guys:

(pluto at agmk dot net) wrote:
>yup, i see something new :)
>
>please look at line 12137 of i8259.i:
>
>__attribute__((regparm(0))) void call_do_IRQ(void); __asm__(...
>
>as you can see there is a semicolon after call_do_IRQ(void)
>and following asm statement isn't treated as a function body.
>in this way -O1 -f{no-}unit-at-a-time accidentally produces
>different code. it's not a gcc bug.
>
>linux-2.4.35/include/asm-i386/hw_irq.h
>contains these evil macros.

is there a chance to fix this?
these macros a far beyond my capabilities to fix.

Axel
