Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZEMNDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZEMNDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZEMNDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:03:07 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58573 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbZEMNDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:03:06 -0400
Date: Wed, 13 May 2009 15:03:02 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       sukadev@linux.vnet.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.30 - /dev/pts - mount options - bisected
In-Reply-To: <6041d2000905081454x4c9d8818oaccbcd14d1f4a506@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0905131440010.28386@vixen.sonytel.be>
References: <6041d2000905081454x4c9d8818oaccbcd14d1f4a506@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Marc Dionne wrote:
> I ran into a regression from 2.6.29 to 2.6.30 on a newly installed
> fedora 11 machine.  The symptom is that things that require /dev/pts
> (gnome-terminal, konsole, xterm, etc.) don't work for a regular user,
> but run fine as root.  Everything is fine with the fedora 2.6.29
> kernel or with a self-compiled 2.6.29, but fail with a recent
> 2.6.30-rc.

When investigating a different issue on Fedora 11 on PS3, I ran into the same
problem with a 2.6.30-rc4 Fedora kernel, and with plain 2.6.30-rc4 kernels
built using a config based on the Fedora config.

> Bisection pinpoints this commit:
> http://git.kernel.org/linus/1bd7903560f1f713e85188a5aaf4d2428b6c8b50
> as the culprit, although I think that's a bit misleading.

I didn't go a far as bisecting, but strace did show it failed on opening
/dev/pts/something.

> Note that I have CONFIG_DEVPTS_MULTIPLE_INSTANCES=y.  It may be that
> user space is doing something unusual, but it passes the test of
> "works with 2.6.29, fails with 2.6.30".

Yes, it works fine with 2.6.29, so it's a regression.

> I wasn't able to reproduce on an other system with a similar configuration.

Originally, I couldn't reproduce the problem with kernels built using my
default config, which has CONFIG_DEVPTS_MULTIPLE_INSTANCES=n.

And indeed, disabling CONFIG_DEVPTS_MULTIPLE_INSTANCES in the Fedora-based
config makes the problem go away, and brings back my terminal-emulators.

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
