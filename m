Return-Path: <linux-kernel-owner+w=401wt.eu-S1161540AbXBOWq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161540AbXBOWq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161613AbXBOWq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:46:59 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:34866 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161540AbXBOWq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:46:58 -0500
Date: Thu, 15 Feb 2007 17:46:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: sparse chokes on arch/i386/kernel/i8253.c (was: 2.6.20-mm1)
Message-ID: <20070215224656.GB6297@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <45D483D7.2040609@imap.cc> <20070215144142.0c13580a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070215144142.0c13580a.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 17:45:39 up 13 days, 12:53,  7 users,  load average: 1.17, 1.95, 1.71
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 15 Feb 2007 17:01:27 +0100
> Tilman Schmidt <tilman@imap.cc> wrote:
> 
> > Trying to build 2.6.20-mm1 on i386 with C=1, sparse 0.2 chokes
> > on arch/i386/kernel/i8253.c:
> > 
> >   CHECK   arch/i386/kernel/i8253.c
> > linux/marker.h: No such file or directory
> > include/linux/jiffies.h:18:5: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:20:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:22:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:24:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:26:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:28:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:30:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> > include/linux/jiffies.h:33:3: error: You lose.
> > include/linux/jiffies.h:225:5: error: bad constant expression
> > include/asm/module.h:64:2: error: unknown processor family
> > include/asm/processor.h:82:30: error: undefined identifier 'CONFIG_X86_L1_CACHE_SHIFT'
> > include/asm/processor.h:82:30: error: bad constant expression type
> > arch/i386/kernel/i8253.c:120:16: error: Expected ; at end of declaration
> > arch/i386/kernel/i8253.c:120:16: error: got pit_read
> > arch/i386/kernel/i8253.c:128:2: error: Trying to use reserved word 'do' as identifier
> > arch/i386/kernel/i8253.c:128:2: error: Expected ; at end of declaration
> > arch/i386/kernel/i8253.c:128:2: error: got {
> > [loads of similar messages omitted ...]
> > arch/i386/kernel/i8253.c:195:2: error: undefined identifier 'clocksource_pit'
> > arch/i386/kernel/i8253.c:196:9: error: undefined identifier 'clocksource_register'
> > arch/i386/kernel/i8253.c:41:7: error: Expected constant expression in case statement
> > arch/i386/kernel/i8253.c:50:7: error: Expected constant expression in case statement
> 
> Me too.  It's due to the linux-kernel-markers patches.  Mathieu, can you
> take a look please?

I will give a deeper look in sparse, but I should say up front that I
add this to the root build tree Makefile :

LINUXINCLUDE    := -Iinclude \
                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
                   -include include/linux/autoconf.h \
                   -include linux/marker.h

I guess sparse is maybe not using this Makefile or variable ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
