Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYHKOki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYHKOki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYHKOjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:39:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbYHKOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:39:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: RFC: killing ksyms.c
Date: Mon, 11 Aug 2008 16:06:43 +0200
User-Agent: KMail/1.9.9
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: linux-arch@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       David Woodhouse <dwmw2@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111606.44103.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UA0DUwp+uyqEWts4rOdotr0MUkmy58OdYUmm
 2FoR++p978Vdlncz10Lt3HUFEiA1u1rx7CLv1uOERcYgYtg/OQ
 YAZgiqzv9+ncfkiU/7j2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw this conversation on IRC when I came back to my screen, and
managed to dig out an older patch of mine:

[19:03:13] <willy> at some point we really need to forbid that
[19:03:28] <willy> bit hard at this point with things like memcpy()
[19:04:36] <willy> could do it with a script of some kind and
           either a whitelist of filenames (arch/*/kernel/ksyms.c
           can export anything) or of functions (anywhere can
           EXPORT_SYMBOL(memcpy)).
[Sun Aug 10 2008] [19:07:35] <viro> I suspect that we really want
           to teach *.S how to do exports
[Sun Aug 10 2008] [19:07:58] <viro> and kill ksyms.c
[Sun Aug 10 2008] [19:12:47] <dwmw2_gone> if we do the -fwhole-program
           --combine thing we'll make it hard anyway

I compile-tested this on powerpc, 32 and 64 bit, and it should be usable as
an example for other architectures.
The idea is to provide an EXPORT_SYMBOL macro for assembly that
behaves in the same way as the C version, and then export every
symbol from the file that defines it.

I'm not sure if the macro I used is actually correct or portable across
all supported architectures, so I hope to get some insight about this
from linux-arch. It does not do genksyms versioned symbol generation
from assembly, but that should be fine since they tend to be really
stable.

	Arnd <><

