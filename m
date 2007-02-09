Return-Path: <linux-kernel-owner+w=401wt.eu-S1946323AbXBIKdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946323AbXBIKdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946347AbXBIKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:33:10 -0500
Received: from mx0.karneval.cz ([81.27.192.15]:57380 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946323AbXBIKdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:33:05 -0500
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Coding style question
Date: Fri, 9 Feb 2007 11:32:09 +0100
User-Agent: KMail/1.9.4
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Pierre Ossman <drzeus@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091132.09741.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have question if next style of macros definitions
for hardware registers is acceptable (tastefull for
maintainers) for Linux kernel.

/* Register offset against peripheral base */
#define SUBSYSTEM_REGISTER_o 0x00000

/* The register field mask */
#define REGISTER_FUNCTION_m 0x00000

/* The register field starting bit */
#define REGISTER_FUNCTION_b 0x00

I am used to use this over many of our embedded
targets mainly developed without operating system.
I would like to use this for Linux drivers as well.

The naming convention has advantage, that it
prevents mistakes, when mask value (*_m) is used
in bit set/clear function without notice instead
of bitnumber (*_b).

The SUBSYSTEM_REGISTER -> REGISTER_FUNCTION
prevents mistakes, when field defined for one register
is used with incorrect register by mistake.

I would like to use this style in i.MX SDHC to
allow support both controllers on MX21.
I would like to use it in other areas as well.

There are tightly copled two macros for preparation
and acquisition of muti-bit masked fields values

#define __val2mfld(mask,val) (((mask)&~((mask)<<1))*(val)&(mask))

#define __mfld2val(mask,val) (((val)&(mask))/((mask)&~((mask)<<1)))

__raw_writel(REGISTER_SINGLEBIT_m |
             __val2mfld(REGISTER_MULTIBIT_m,value),
             periph_base + SUBSYSTEM_REGISTER_o)

x = __mfld2val(REGISTER_MULTIBIT_m,
           _raw_readl(periph_base + SUBSYSTEM_REGISTER_o))

The macros seems to be complicated, but they generate optimal
code for constant fields masks. I am not aware, that there
is some commonly available alternative in Linux kernel
header files.

Suggestions, names corrections etc. are welcomed.
If you think, that it is not good idea to introduce
yet another style, I would try to follow actual style
found in each source file. If you prefer some already
utilized style, direct me to right examples, please.

Best wishes

              Pavel Pisa
