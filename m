Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYEYSui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYEYSui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYEYSua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:50:30 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:35726 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbYEYSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:50:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:49:39 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org> <orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252049.39731.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 19:17:57 Alexandre Oliva wrote:
> On May 25, 2008, Marcel Holtmann <marcel@holtmann.org> wrote:
> 
> > in the early days we had something like three drivers using the
> > request_firmware() and it was understood between the authors what the
> > filename was meant for.
> 
> You're contradicting yourself.  Is it a filename, or is it not?
> Earlier, you said it wasn't, it was just a name that userspace was
> supposed to map to a filename.  Now, you're saying it is a filename.
> 
> Clearly (to me) your wish to prohibit '/'s in the firmware name has to
> do with an attempt to force a distiction, to make the firmware a
> filename rather than a pathname.  But, as you said yourself, the
> mapping from firmware name is supposed to be entirely handled in
> userland, therefore it doesn't even begin to make sense to distinguish
> between filenames and pathnames.  You'd have to make assumptions that
> (i) the firmware name names files (with built-in firmware, it
> doesn't), and, if it is about filenames, (ii) what the pathname
> separator character is.  Should '\\' be ruled out as well, because
> someone might want /lib/firmware to be in a FAT filesystem?
> 
> nWouldn't it be better to leave the resolution of firmware names to
> content *entirely* up to userland?  Say, if userland wants to
> implement something very similar to the key-to-data map in-kernel
> built-in firmware, this would work just fine, without any artificial
> constraints?

One additional thing is to make sure the usability of the whole stuff
is not reduded. Currently I can do:

modprobe b43 fwpostfix=-open
# work with opensource firmware in b43-open/
rmmod b43
modprobe b43
# work with standard firmware in b43/

So it is really simple to switch between different flavours of firmware.
It is _not_ acceptable to change an udev configuration file all the time,
if you want to use another firmware. One needs to frequently switch
between firmware versions when developing firmware code.

-- 
Greetings Michael.
