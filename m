Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbYERSvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbYERSvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbYERSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:42:34 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63907 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758490AbYERSmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:42:33 -0400
Date: Sun, 18 May 2008 19:38:41 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Tom Spink <tspink@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
In-Reply-To: <20080518180811.GI8140@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.55.0805181934220.16640@cliff.in.clinika.pl>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com>
 <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de>
 <482FD9F2.8080204@goop.org> <20080518180811.GI8140@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Adrian Bunk wrote:

> Even more important:
> How do you want to handle kconfig variables set to "m"?
> 
> Expand them to 0.5 ?  ;-)

 :-)

 Modules use a separate set of variables with _MODULE appended to their 
names.  Thus for an option FOO, you'll get:

#undef CONFIG_FOO
#undef CONFIG_FOO_MODULE

if it's set to "n",

#define CONFIG_FOO 1
#undef CONFIG_FOO_MODULE

if it's set to "y", and

#undef CONFIG_FOO
#define CONFIG_FOO_MODULE 1

if it's set to "m".  Individual tests may check these both as they find 
appropriate.

  Maciej
