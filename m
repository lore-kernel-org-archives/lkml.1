Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbYBOOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbYBOOuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYBOOuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:50:11 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:36729 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754545AbYBOOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:50:09 -0500
Date: Fri, 15 Feb 2008 15:50:07 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Machine check exception with a kernel dependency
Message-ID: <20080215145007.GA18341@janus>
References: <20080213162528.GA32635@janus> <20080215132241.23823d43@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215132241.23823d43@core>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 01:22:41PM +0000, Alan Cox wrote:
> On Wed, 13 Feb 2008 17:25:28 +0100
> Frank van Maarseveen <frankvm@frankvm.com> wrote:
> 
> > On at least two Dell optiplex 755 systems with a Core 2 Duo I get
> > 
> > Feb 13 15:14:01 inari CPU 1: Machine Check Exception: 0000000000000004 
> > Feb 13 15:14:01 inari CPU 0: Machine Check Exception: 0000000000000005 
> > Feb 13 15:14:01 inari Bank 0: b200004000000800 
> > Feb 13 15:14:01 inari Bank 5: b200221024080400 
> > 
> > 2.6.22.10 shows the problem, 2.6.24.2 ditto but I'm unable to reproduce
> > it with 2.6.24-rc8. BIOS upgrade didn't help. Removing all PCI[e] cards
> > didn't help either.
> 
> If you run the MCE numbers through a decoder what do you get back ?

I've some trouble decoding these in a convincing way. mcelog --core2
--ascii reports "MCG status:RIPV MCIP" for 0000000000000005 and "MCG
status:MCIP" for 0000000000000004.

I've collected several Bank # output lines:

#  text
---------------------------
26 Bank 0: b200004000000800
10 Bank 5: b200121014040400
 8 Bank 5: b200121020080400
 4 Bank 5: b200221010040400
 4 Bank 5: b200221024080400

but mcelog expects lines of the format

	CPU %u: Machine Check Exception: %16Lx Bank %d: %016Lx

(they got broken by netconsole) so I made these up:

CPU 1: Machine Check Exception: 0000000000000004 Bank 0: b200004000000800
CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200121014040400
CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200121020080400
CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200221010040400
CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200221024080400

result:

CPU 1: Machine Check Exception: 0000000000000004 Bank 0: b200004000000800
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 BANK 0 MCG status:MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: BUS Level-0 Originated-request Generic Memory-access Request-timeout Error
BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
timeout BINIT (ROB timeout)
STATUS b200004000000800 MCGSTATUS 4

CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200121014040400
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 5 MCG status:RIPV MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200121014040400 MCGSTATUS 5

CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200121020080400
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 5 MCG status:RIPV MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200121020080400 MCGSTATUS 5

CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200221010040400
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 5 MCG status:RIPV MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200221010040400 MCGSTATUS 5

CPU 0: Machine Check Exception: 0000000000000005 Bank 5: b200221024080400
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 5 MCG status:RIPV MCIP 
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200221024080400 MCGSTATUS 5


The problem also exists on an entirely different Xeon system with 4 cores:

cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU           X3210  @ 2.13GHz
stepping        : 11


-- 
Frank
