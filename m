Return-Path: <linux-kernel-owner+w=401wt.eu-S933743AbXHFNco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbXHFNco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765530AbXHFNbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:31:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:55747 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615AbXHFNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MOAAYaMd/udK2SsPmASR6CdHIM/OokJIv6399tww3dhqNRPjUJXgKDBw9kA+M/ZbVIfRxOR/HQ5oZGOzjqH4JYPUbKuXkC+y+/HSzvXgK6HlZtUuq8nvFu4p3kvn/5NUOmk7lOBwhXz8c71zFto47mSurmeLHFr5MkE1RozPvuA=
Message-ID: <ee9e417a0708060631h72595d28le9de0d13f21cb658@mail.gmail.com>
Date: Mon, 6 Aug 2007 09:31:28 -0400
From: "Russ Cox" <rsc@swtch.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix selector unit bug affecting some USB speakerphones
In-Reply-To: <20070621234846.56F401E8C22@holo.morphisms.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070621234846.56F401E8C22@holo.morphisms.net>
X-Google-Sender-Auth: 8f542412cf87b8f4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My reading of the maintainers file is that
sound/usb/usbmixer.c belongs to perex@suse.cz
but I got no response to this message, so I am
resending it here.

Russ

---------- Forwarded message ----------
From: Russ Cox <rsc@swtch.com>
Date: Jun 21, 2007 7:48 PM
Subject: [PATCH] fix selector unit bug affecting some USB speakerphones
To: perex@suse.cz

Following the suggestion in this thread:
https://bugs.launchpad.net/ubuntu/+source/alsa-lib/+bug/26683
the correct upper bound on desc[0] is 5 + num_ins not 6 + num_ins,
because the index used later is 5+i, not 6+i.

This change makes my Vosky Chatterbox speakerphone work.
Apparently it also helps with the Minivox MV100.

Signed-off-by: Russ Cox <rsc@swtch.com>

---
 sound/usb/usbmixer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/usb/usbmixer.c b/sound/usb/usbmixer.c
index 325d4b6..19776e7 100644
--- a/sound/usb/usbmixer.c
+++ b/sound/usb/usbmixer.c
@@ -1483,7 +1483,7 @@ static int parse_audio_selector_unit(struct
mixer_build *state, int unitid, unsi
        struct snd_kcontrol *kctl;
        char **namelist;

-       if (! num_ins || desc[0] < 6 + num_ins) {
+       if (! num_ins || desc[0] < 5 + num_ins) {
                snd_printk(KERN_ERR "invalid SELECTOR UNIT descriptor
%d\n", unitid);
                return -EINVAL;
        }
--
1.4.4.2
