Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYEYT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYEYT1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYEYT1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:27:18 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:49606 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757101AbYEYT1R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:27:17 -0400
X-Greylist: delayed 2637 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 15:27:15 EDT
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 25 May 2008 14:17:57 -0300
In-Reply-To: <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org> (Marcel Holtmann's message of "Sun\, 25 May 2008 13\:49\:48 +0200")
Message-ID: <orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25, 2008, Marcel Holtmann <marcel@holtmann.org> wrote:

> in the early days we had something like three drivers using the
> request_firmware() and it was understood between the authors what the
> filename was meant for.

You're contradicting yourself.  Is it a filename, or is it not?
Earlier, you said it wasn't, it was just a name that userspace was
supposed to map to a filename.  Now, you're saying it is a filename.

Clearly (to me) your wish to prohibit '/'s in the firmware name has to
do with an attempt to force a distiction, to make the firmware a
filename rather than a pathname.  But, as you said yourself, the
mapping from firmware name is supposed to be entirely handled in
userland, therefore it doesn't even begin to make sense to distinguish
between filenames and pathnames.  You'd have to make assumptions that
(i) the firmware name names files (with built-in firmware, it
doesn't), and, if it is about filenames, (ii) what the pathname
separator character is.  Should '\\' be ruled out as well, because
someone might want /lib/firmware to be in a FAT filesystem?

nWouldn't it be better to leave the resolution of firmware names to
content *entirely* up to userland?  Say, if userland wants to
implement something very similar to the key-to-data map in-kernel
built-in firmware, this would work just fine, without any artificial
constraints?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
