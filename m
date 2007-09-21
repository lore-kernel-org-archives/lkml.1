Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbXIUTHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbXIUTHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762124AbXIUTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:07:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762056AbXIUTHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NGE4HBvk3uxwTUh4LWV/vfX7a/M0BBi3S2fDFOePWuSUrxZx4n7+KbvnJrRyHy26FEYZrzqVwUwX6vHdVxpRYKNI+Hb2JAi2OuofaretDlRznlOSm8InlFRb2bVdLlQc41656z4VKfpwpiKZqGhsLF2AhrPwRicBqfIY/RyeuDg=
Subject: Redundent/missing code in dik_show_trace
	(arch/alpha/kernel/traps.c)
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 21 Sep 2007 21:07:15 +0200
Message-Id: <1190401635.6759.7.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

As the title suggest.
"i" is declared as 0 and never assigned a new value.
Down the code there's an if (i>40) and a certain dangling piece of code.
I assume that I should have gotten a string length (?) from somewhere?

Am I missing something?

- Gilboa

---
static void
dik_show_trace(unsigned long *sp)
{
	long i = 0;
	printk("Trace:\n");
	while (0x1ff8 & (unsigned long) sp) {
		extern char _stext[], _etext[];
		unsigned long tmp = *sp;
		sp++;
		if (tmp < (unsigned long) &_stext)
			continue;
		if (tmp >= (unsigned long) &_etext)
			continue;
		printk("[<%lx>]", tmp);
		print_symbol(" %s", tmp);
		printk("\n");
		if (i > 40) {
			printk(" ...");
			break;
		}
	}
	printk("\n");
}


