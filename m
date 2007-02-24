Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXBXNuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXBXNuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932822AbXBXNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:50:25 -0500
Received: from mail.enyo.de ([212.9.189.167]:1051 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830AbXBXNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:50:24 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Undo some of the pseudo-security madness
References: <87r6toufpp.wl@betelheise.deep.net>
	<ep0tb0$f6e$1@taverner.cs.berkeley.edu>
	<1D317613-B0B6-4517-81B5-DBF3978FA413@mac.com>
	<87lkjvvnc6.wl@betelheise.deep.net> <87k5y799lo.fsf@mid.deneb.enyo.de>
	<87irdrbry6.wl@betelheise.deep.net>
Date: Sat, 24 Feb 2007 14:49:34 +0100
In-Reply-To: <87irdrbry6.wl@betelheise.deep.net> (Samium Gromoff's message of
	"Sat, 24 Feb 2007 16:33:53 +0300")
Message-ID: <87d53z1x8x.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Samium Gromoff:

>> > Lisp environments can produce standalone executables
>> 
>> If you've got a stand-alone executable, you don't need MAP_FIXED.  The
>> ELF loader maps the program at a fixed address anyway (at least on
>> i386 and x86_64, I haven't checked others).
>
> Not so.
>
> The thing is that the picture is of two pieces:
>
>  - the executable
>  - the unrelocatable lisp core (which is unrelocatable by the virtue
>    of non-PIC code) which is mapped into the AS of the executable.
>
> It is the latter which breaks, as its map can overlap with randomized
> pieces of the executable (along with its libraries).

I think it boils down to the question if you can use ELF relocations
to create a relocatable (but not necessarily position-independent)
object that ld can link with the SBCL run-time system to produce an
executable.  This executable would truly be stand-alone because no
separate core file is required anymore.
