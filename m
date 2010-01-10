Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828Ab0AJMod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0AJMod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354Ab0AJMoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:44:32 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:49374 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0AJMob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:44:31 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Tim Abbott <tabbott@ksplice.com>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros." and  old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new  email address)
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
X-Yow: I guess it was all a DREAM..  or an episode of HAWAII FIVE-O...
Date: Sun, 10 Jan 2010 13:44:26 +0100
In-Reply-To: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
	(Geert Uytterhoeven's message of "Sun, 10 Jan 2010 10:28:26 +0100")
Message-ID: <m23a2egmdx.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Sun, Jan 10, 2010 at 05:56, Michael Schmitz
> <schmitz@biophys.uni-duesseldorf.de> wrote:
>>> > > I'll verify that on the new tree, and start bisecting. Sigh.
>>> >
>>> > Good luck!
>>>
>>> 7c5fd5619dc89fb52d2c2cf144fc6e4365427b86 is first bad commit
>>> commit 7c5fd5619dc89fb52d2c2cf144fc6e4365427b86
>>> Author: Tim Abbott <tabbott@ksplice.com>
>>> Date:   Sun Sep 27 13:57:55 2009 -0400
>>>
>>>     m68k: Cleanup linker scripts using new linker script macros.
>>>
>>>     Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>>>     Tested-by: Andreas Schwab <schwab@linux-m68k.org>
>>>     Cc: Roman Zippel <zippel@linux-m68k.org>
>>>     Cc: Sam Ravnborg <sam@ravnborg.org>
>>>     Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>
>>> :040000 040000 5bdbf7ce5dd4ea2f23669c6a6ec11192865b5bfa
>>> d3b7397533b0af6261747ccef3cff9cd40f6baf9 M    arch
>>
>> Backing out that commit on the top of the tree results in a bootable
>> 2.6.33-rc2 for me
>>
>> The order of symbols in the system map is different (as you would expect)
>> but I don't see what implicit assumption would be violated.
>
> Tim, any clues? Michael is using gcc 3.3.6 and binutils 2.16.
> It works fine with my 4.1.2/2.18 vombo.

Most likely an alignment issue so that the bootinfo structure is not
found.  At least that was the issue with previous incarnations of the
patch.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
