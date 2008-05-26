Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYEZDby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYEZDby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 23:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYEZDbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 23:31:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYEZDbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 23:31:44 -0400
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<1211550374.28967.10.camel@pmac.infradead.org>
	<20080523164108.GA31545@uranus.ravnborg.org>
	<1211640377.540.14.camel@pmac.infradead.org>
	<20080524152214.GA12582@uranus.ravnborg.org>
	<1211642706.31212.85.camel@shinybook.infradead.org>
	<1211643245.31212.88.camel@shinybook.infradead.org>
	<D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
	<1211707837.17151.14.camel@johannes.berg>
	<95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	<orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4A84E98F-1C0D-4194-AC63-5455CCD5DD35@holtmann.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 26 May 2008 00:30:04 -0300
In-Reply-To: <4A84E98F-1C0D-4194-AC63-5455CCD5DD35@holtmann.org> (Marcel Holtmann's message of "Sun\, 25 May 2008 20\:49\:38 +0200")
Message-ID: <orzlqdyc77.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25, 2008, Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Alexandra,
>>> in the early days we had something like three drivers using the
>>> request_firmware() and it was understood between the authors what the
>>> filename was meant for.
>> 
>> You're contradicting yourself.  Is it a filename, or is it not?
>> Earlier, you said it wasn't, it was just a name that userspace was
>> supposed to map to a filename.  Now, you're saying it is a filename.

> it is a filename with any directory components.

You can't have it both ways.  Either it is a firmware name in a flat
namespace that userland is supposed to map however it wants to data,
or it is a filename that userland can map in more limited ways
*because* you declared it to be a filename.

Unless...

Are we talking of different things?

I thought you were talking about the string presented to userland to
request firmware to be loaded, but if you're talking about say
pathnames within /sys, I can see how supporting directories et al
could make things more complex and undesirable.

AFAICT by perusing the code for a few seconds, the name within /sys
that is created to receive the firmware code and the string that
userland is requested to resolve to the firmware code are currently
the same, but I don't quite see that there's a reason that requires it
to be so.

>> Should '\\' be ruled out as well, because someone might want
>> /lib/firmware to be in a FAT filesystem?

> Actually the request_firmware() is Linux specific :)

Last I looked Linux supported FAT filesystems.  If someone wanted
/lib/firmware to be FAT, why should this not be permitted?  What's
your point?

> And again the grouping into subdirectories should have been fixed in
> userspace by reading the driver name.

You appear to be assuming that driver name is the only reason and
criterium for grouping firmware files.  Any particular reason to force
this one-level grouping model, rather than permitting hierarchical
grouping, that might make more sense?

> The kernel should not do this at all.

And AFAICT ATM it doesn't, and that's how it should be.  Let's not
conflate userland implementation with in-kernel naming of firmwares.
These are orthogonal issues.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
