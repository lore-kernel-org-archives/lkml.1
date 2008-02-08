Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbYBHQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbYBHQjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933856AbYBHQij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:38:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848AbYBHQii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:38:38 -0500
From: Andreas Schwab <schwab@suse.de>
To: abelbg@m2grp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Elf loader crash while zero-filling .bss
References: <15577be70801300309k4eb84047peb4bffd4b41cbaa7@mail.gmail.com>
	<15577be70801310738x3afcc393k6cf8f7151677528c@mail.gmail.com>
	<15577be70802080814j1bb21b30r6f8a82e35aa8dc07@mail.gmail.com>
X-Yow: As a FAD follower, my BEVERAGE choices are rich and fulfilling!
Date: Fri, 08 Feb 2008 17:38:33 +0100
In-Reply-To: <15577be70802080814j1bb21b30r6f8a82e35aa8dc07@mail.gmail.com>
	(Abel Bernabeu's message of "Fri\, 8 Feb 2008 17\:14\:50 +0100")
Message-ID: <jefxw3pfna.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Abel Bernabeu" <abelbg@m2grp.com> writes:

> The offset of some sections fall in the middle of the .bss section. In
> instance, look at the sections 12 (.comment) and 13 (.ARM.atributes).
> Both sections are overlapping with 11 (.bss):
>
> [11] .bss                 NOBITS       0001143c 00143c 000048  0 WA     0   0  4
> [12] .comment             PROGBITS     00000000 00143c 000094  0        0   0  1
> [13] .ARM.attributes      SHT_LOPROC+3 00000000 0014d0 000010  0        0   0  1
> [14] .shstrtab            STRTAB       00000000 0014e0 00007b  0        0   0  1
> [15] .symtab              SYMTAB       00000000 001804 000c70 16       16  92  4
> [16] .strtab              STRTAB       00000000 002474 000840  0        0   0  1
>
> Is this fact meaningful??

The fifth column is the file offset.  Since the .bss section does not
occupy any file space the other sections can be put directly behind it
in the file.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
