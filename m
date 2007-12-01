Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXLAMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXLAMMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 07:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXLAMMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 07:12:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:3850 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbXLAMMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 07:12:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kU3cmAhtMwI/Q35mEQjCi0D+UYtKV6dXx3mFdfazy3d5316DziX9DrB0qhH8GSZjNGG2CIC62Spv7cqQ+8Bsn3qlcQDIExtozNxAbnigU1Pgys6pfqUTSNpddvPzxbEEVOuhT7mAtWjst7kte9HwZqjWOIkuqZr4fk83foUiikY=
Date: Sat, 1 Dec 2007 15:12:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible BUG: unable to handle kernel NULL pointer dereference
	at virtual address 00000000
Message-ID: <20071201121220.GA28875@cvg>
References: <47481590.8090009@xs4all.nl> <200711241951.37817.rjw@sisk.pl> <474870F5.4050504@xs4all.nl> <aa79d98a0711270340q5fd6b8a0o5076052a4411e6b2@mail.gmail.com> <474C3659.600@xs4all.nl> <20071127164929.GA7279@cvg> <474C56C8.80206@xs4all.nl> <20071127175503.GC7279@cvg> <47513EE5.30703@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47513EE5.30703@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Udo van den Heuvel - Sat, Dec 01, 2007 at 12:00:53PM +0100]
| Hallo Cyrill,
| 
| Cyrill Gorcunov wrote:
| > | I made a do while loop doing make bzImage modules and a make clean.
| > | Should be OK?
| > | 
| > 
| > well, test the patch enveloped. if the bug is really heppens then
| > BUG message should appear. and the thing is much important - does
| > that bug appears on the same actions (make bzImage and etc..) on pure
| > kernel? or that happened from time to time?
| 
| I only had teh bug once, that was the reason for my post.
| Since then the system has been busy, with intervals, doing kernel
| compiles and no repeat of the BUG yet...
| It's a VIA EN12000 with 1GB of RAM. How could I increase the chances of
| hitting it?
| 
| 
| Kind regards,
| Udo
|

Hi Udo,

if my guessing is right - the only chance to hit it faster - is to increase
files' activity i.e. compiling the kernel involves a lot of file being readed
thru dcache system. First we have to locate the bug on a pure kernel
and 'case it's a rare thing to happen... well I don't really know how to
get it up to known point. So i think you could play with a pure kernel
by compiling it or run several copies of 'grep' thru kernel searching
the same pattern like "grep -r -n for ./*" in kernel sources. But Udo,
I'm not a kernel specialist so my suggestions could be not really usefull ;)

And as only you have found "approximated events" when the bug happend -
then we could try the same actions with my latest patch applied to find
if it happening exactly in dcache system. (damn, so many *if* there ;)

if you will not find that bug being reproducible in a simple way - just
leave all as it is, i'm trying to find problems in dcache system by code
reading.

P.S.
Lets CC LKML - that could help us ;)

		Cyrill

