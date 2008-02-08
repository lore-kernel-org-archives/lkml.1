Return-Path: <linux-kernel-owner+w=401wt.eu-S935530AbYBHSJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935530AbYBHSJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934959AbYBHSGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:06:00 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:30076 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955AbYBHSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L/mKGrnejkXMdvggkjgWRccu524m155frl3M/cEL8gfQK88OYV+26mmbxXS+InmaLMEv/lof9C/DOHfM48GBRiMMnV8oKdgQZwQu8koDMXSHKDTQw3H9Fjkk8t5BuFgDROEQfNyepyXO/6gzu3/fNroYrO3TYiTfJjGDX5tj4WA=
Message-ID: <15577be70802081005t254c4ebcwc0dc9e5fe97eb975@mail.gmail.com>
Date: Fri, 8 Feb 2008 19:05:48 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: linux-kernel@vger.kernel.org
Subject: Fwd: Elf loader crash while zero-filling .bss
In-Reply-To: <15577be70802080954w6796bed1mbdf5fdc52e0cb2bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15577be70801300309k4eb84047peb4bffd4b41cbaa7@mail.gmail.com>
	 <15577be70801310738x3afcc393k6cf8f7151677528c@mail.gmail.com>
	 <15577be70802080814j1bb21b30r6f8a82e35aa8dc07@mail.gmail.com>
	 <jefxw3pfna.fsf@sykes.suse.de>
	 <15577be70802080954w6796bed1mbdf5fdc52e0cb2bf@mail.gmail.com>
X-Google-Sender-Auth: c39021d92c4cc404
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Abel Bernabeu <abelbg@m2grp.com>
Date: 08-feb-2008 18:54
Subject: Re: Elf loader crash while zero-filling .bss
To: Andreas Schwab <schwab@suse.de>


2008/2/8, Andreas Schwab <schwab@suse.de>:
> "Abel Bernabeu" <abelbg@m2grp.com> writes:
>
> > The offset of some sections fall in the middle of the .bss section. In
> > instance, look at the sections 12 (.comment) and 13 (.ARM.atributes).
> > Both sections are overlapping with 11 (.bss):
> >
> > [11] .bss                 NOBITS       0001143c 00143c 000048  0 WA     0   0  4
> > [12] .comment             PROGBITS     00000000 00143c 000094  0        0   0  1
> > [13] .ARM.attributes      SHT_LOPROC+3 00000000 0014d0 000010  0        0   0  1
> > [14] .shstrtab            STRTAB       00000000 0014e0 00007b  0        0   0  1
> > [15] .symtab              SYMTAB       00000000 001804 000c70 16       16  92  4
> > [16] .strtab              STRTAB       00000000 002474 000840  0        0   0  1
> >
> > Is this fact meaningful??
>
> The fifth column is the file offset.  Since the .bss section does not
> occupy any file space the other sections can be put directly behind it
> in the file.
>

The standar says literally that sections cannot overlap... but your
interpretation is rigth anyway.

I have a lot of binaries in my host Linux system with some section
overlapping with .bss wich are correctly loaded (so this should not be
the problem).

Well, let's follow searching...

I already tested the filesystem (in order to discard a flash corruption).

Yours, Abel.
