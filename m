Return-Path: <linux-kernel-owner+w=401wt.eu-S1764402AbXGJSgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764402AbXGJSgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXGJSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:35:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXGJSf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:35:56 -0400
Message-ID: <4693D183.9060604@zytor.com>
Date: Tue, 10 Jul 2007 11:35:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 16/33] String-handling functions for the new x86 setup
 code.
References: <11840359321823-git-send-email-hpa@zytor.com> <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com> <Pine.LNX.4.64.0707102022400.11053@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707102022400.11053@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 9 2007 19:51, H. Peter Anvin wrote:
>> strcmp(), memcpy(), memset(), as well as routines to copy to and from
>> other segments (as pointed to by fs and gs).
> 
> I wonder, strcmp() is the only one not done in assembler.
> Is there a particular reason? (Or the other way around, why
> is memcpy/memset not C.) The opcode is rep[n]z cmps[bl];

BZZT, wrong.  repz cmpsb is memcmp(), not strcmp().  The reason is
simply that memset and memcpy are in assembly is that they are simple
wrappers around string instructions, plus the need to provide the
other-segment copy functions -- it was cleaner to do them as an assembly
file.

This is not the case for strcmp(), nor for any other string functions
that may want to be used in the future.

> Would perhaps using __builtin_memset
> and whatever GCC provides also work in 16-bit mode (would save
> implementing it again).

Nope.  The builtins not only vary between gcc versions, but they also
have a nasty tendency to generate calls to library functions, sometimes
libgcc functions.  Hence -ffreestanding.

>> +/*
>> + * arch/i386/boot/string.c
>> + *
>> + * Very basic string functions
>> + */
>> +
>> +#include "boot.h"
>> +#include <linux/edd.h>
> 
> What's edd good for here?

It's a copy-and-paste accident; already fixed in the tree.

	-hpa
