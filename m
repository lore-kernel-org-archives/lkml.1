Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZFVXIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZFVXIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZFVXHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:07:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63826 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZFVXHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:07:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Tue, 23 Jun 2009 01:07:42 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Chris Simmonds <chris@2net.co.uk>, Marco <marco.stornelli@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A33A7EC.6070008@gmail.com> <4A3FDBFE.8050509@2net.co.uk> <20090622214155.GA19332@logfs.org>
In-Reply-To: <20090622214155.GA19332@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200906230107.43667.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18qbre0CGs2DPIqOSKzNpWiiaTe+lvJl0eTUYk
 4AxcaLCaFDR/MjFEdyNmVeENwyqYcjUzd/krMwQ/XEk4OIjkYf
 3P6+MrEnK6HHDq9nD4S/G2alw2ZCjnL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Jörn Engel wrote:
> Four loops doing the same increment with different data types: long,
> u64, we32 (wrong-endian) and we64.  Compile with no optimizations.
> 
> Results on my i386 notebook:
> long:     453953 us
> we32:     880273 us
> u64:      504214 us
> we64:    2259953 us
> loops: 100000000

(couldn't resist)

The we64 number is artificially high because the glibc bswap_64
implementation forces the conversion to be done on the stack.
Using __builtin_bswap64 make this look more logical, and
makes your point even stronger (on core 2, using -m32):

long:     236792 us
we32:     500827 us
u64:      265990 us
we64:     757380 us
loops: 100000000

	Arnd <><
