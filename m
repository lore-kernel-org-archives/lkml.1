Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYKXTEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYKXTEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKXTEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:04:47 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:36507 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYKXTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:04:46 -0500
Date: Mon, 24 Nov 2008 19:04:40 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       David Daney <ddaney@caviumnetworks.com>, gcc@gcc.gnu.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org,
       Adam Nemet <anemet@caviumnetworks.com>
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
In-Reply-To: <20081121221619.GB28154@linux-mips.org>
Message-ID: <alpine.LFD.1.10.0811241854520.3793@ftp.linux-mips.org>
References: <49260E4C.8080500@caviumnetworks.com> <20081121100035.3f5a640b@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0811211126420.26004@anakin> <4926E499.4070706@caviumnetworks.com> <Pine.LNX.4.64.0811211940450.29539@anakin>
 <20081121221619.GB28154@linux-mips.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Ralf Baechle wrote:

> MIPS ISA newer than MIPS I also have conditional break codes allowing
> something like this:
> 
> #define BUG_ON(condition)                                               \
> do {                                                                    \
>         __asm__ __volatile__("tne $0, %0, %1"                           \
>                              : : "r" (condition), "i" (BRK_BUG));       \
> } while (0)
> 
> that is test of condition and the trap as a single instruction.  Note there
> are break and trap instructions on MIPS and they are basically doing the
> same job ...

 GCC is actually smart enough to combine sequences like:

if (something)
	__builtin_trap();

into appropriate conditional trap instructions on MIPS.  As noted by David 
trap codes other than the default cannot be emitted this way though.

  Maciej
