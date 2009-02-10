Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZBJTGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZBJTGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZBJTDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:32 -0500
Received: from kroah.org ([198.145.64.141]:53639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754725AbZBJTDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:31 -0500
Date: Tue, 10 Feb 2009 10:59:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 07/53] sound: usb-audio: handle wMaxPacketSize for
	FIXED_ENDPOINT devices
Message-ID: <20090210185954.GH14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sound-usb-audio-handle-wmaxpacketsize-for-fixed_endpoint-devices.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 894dcd78782842924527598b0b764c9b4e679e21 upstream.

For audio devices that do not have proper audio descriptors (e.g.,
Edirol UA-20), we use hardcoded parameters from our quirks list.
However, we must still read the maximum packet size from the standard
endpoint descriptor; otherwise, we might use packets that are too big
and therefore rejected by the USB core.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -2966,6 +2966,7 @@ static int create_fixed_stream_quirk(str
 		return -EINVAL;
 	}
 	alts = &iface->altsetting[fp->altset_idx];
+	fp->maxpacksize = le16_to_cpu(get_endpoint(alts, 0)->wMaxPacketSize);
 	usb_set_interface(chip->dev, fp->iface, 0);
 	init_usb_pitch(chip->dev, fp->iface, alts, fp);
 	init_usb_sample_rate(chip->dev, fp->iface, alts, fp, fp->rate_max);

