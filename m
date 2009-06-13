Return-Path: <linux-kernel-owner+w=401wt.eu-S1762883AbZFMUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbZFMUcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZFMUcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:32:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZFMUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:32:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] FRV: Fix interaction with new generic header stuff
Date: Sat, 13 Jun 2009 22:31:48 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20090613122354.24795.88926.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090613122354.24795.88926.stgit@warthog.procyon.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906132231.49327.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Uy4e0knKcskOZxcH0dZpYk80YJ1BKWdem8q/
 o/PvMjMlnA3gC3zgpCzSmUg7guTWpuRDllzd2MVYOGVfpsjOPD
 F1Jl70/h+ws3d5BioLoVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, David Howells wrote:
> Fix interaction with new generic header stuff as added by:
> 
>         commit 6103ec56c65c33774c7c38652c8204120c3c7519
>         Author: Arnd Bergmann <arnd@arndb.de>
>         Date:   Wed May 13 22:56:27 2009 +0000
> 
>             asm-generic: add generic ABI headers
> 
> The problem is that asm/signal.h has been made to include asm-generic/signal.h,
> but the redundant stuff from asm/signal.h has not been discarded, leading to
> multiple redefinitions.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

This was the result of an incorrectly resolved merge conflict on my side,
after you moved the frv headers around. I fixed the same bug for other
architectures, but frv has slipped through for some reason.

My intended fix was to simply change #include <asm-generic/signal.h>
to #include <asm-generic/signal-defs.h>, which would have been guaranteed
to be non-invasive. Your change of course is the long-term cleanup
that reuses the asm-generic file.

Sorry about the breakage.

	Arnd <><
