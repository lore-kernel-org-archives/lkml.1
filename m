Return-Path: <linux-kernel-owner+w=401wt.eu-S1764425AbXF1MUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764425AbXF1MUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbXF1MU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:20:29 -0400
Received: from smtpout.mac.com ([17.250.248.174]:62181 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521AbXF1MU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:20:29 -0400
In-Reply-To: <1183030574.1170.137.camel@pmac.infradead.org>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com> <20070627155715.60ebc48f.randy.dunlap@oracle.com> <20070627161648.52d3786d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706280411520.26289@anakin> <Pine.LNX.4.64.0706280844030.22579@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0706281333320.24833@anakin> <1183030574.1170.137.camel@pmac.infradead.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6879F938-78C9-4FE1-B5EA-C558A54A5E70@mac.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Thu, 28 Jun 2007 08:20:24 -0400
To: David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, at 07:36:14, David Woodhouse wrote:
> On Thu, 2007-06-28 at 13:34 +0200, Geert Uytterhoeven wrote:
>> We do not support building Linux with Turbo C (or MS Visual C for  
>> Win64 P64).
>
> We're talking about types which are exposed to userspace.

Yes, and all 64-bit software built using kernel headers must be built  
in LP64 mode, anything else is pure insanity.  On LP64 (IE: how the  
kernel itself is compiled on EVERY 64-bit arch):

char == 8 bits
short == 16 bits
int == 32 bits
long == 64 bits
pointer == 64 bits
long long == 64 bits

On LP32 (IE: how the kernel itself is compiled on EVERY 32-bit arch):

char == 8 bits
short == 16 bits
int == 32 bits
long == 32 bits
pointer == 32 bits
long long == 64 bits

Ergo we can simply require that if you want to use kernel headers you  
must be using the same mode as the kernel is compiled in (LP32 or LP64).

The simplest guaranteed-not-to-break way to do this on _every_  
supported platform is:
typedef   signed char  __s8;
typedef unsigned char  __s8;
typedef   signed short __s16;
typedef unsigned short __s16;
typedef   signed int   __s32;
typedef unsigned int   __s32;
# if __STDC_VERSION__ >= 19901L
typedef   signed long long __s64;
typedef unsigned long long __s64;
# elif defined(__GNUC__)
__extension__ typedef   signed long long __s64;
__extension__ typedef unsigned long long __s64;
# endif

If you have some other compiler that works under linux *AND* supports  
a 64-bit type in non-C99-mode (whether "long long" or something  
else), then they are welcome to submit patches to fix it.

Cheers,
Kyle Moffett

