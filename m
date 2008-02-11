Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYBKU66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYBKU66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYBKU6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:58:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:16453 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYBKU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:date:user-agent:mime-version:content-disposition:to:cc:content-type:content-transfer-encoding:message-id;
        b=ouED89O5i/qq34XaKKzmL55RV9KmxAi7TMfPGL5VqxpfEYahu5/asqazlHy4JxjlnNziMGAqzfC0vo7dGFAtEyxRhIhVSv3fRydm/Ez5JQqZBRX/LmEYOY0BoUaaI7ARpqJ1eVCfCoPzRGO3DgFhusfTE2P80Nv50zmOI7SzW5I=
From: Matej Laitl <strohel@gmail.com>
Subject: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Mon, 11 Feb 2008 21:58:41 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200802112158.41989.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
after upgrading from 2.6.24 to 2.6.25-rc1, I lost headphone-out sound output 
of my Intel HDA card - it is quiet no matter what the mixer settings are.

After playing wit git bisect a bit, I narrowed it down to commit 
f889fa91ad47e "[ALSA] hda-codec - Improve the auto-configuration". [1]
It works okay with tree as of previous commit 69b1f1e8337fc9. 

First lines from /proc/asound/Intel/codec#0:
Codec: Realtek ALC262
Address: 0
Vendor Id: 0x10ec0262
Subsystem Id: 0x17340000
Revision Id: 0x100202
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0

The box is Fujitsu-Siemens Esprimo Mobile M9400 laptop.

[1] 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f889fa91ad47e6fcb530abf1184ca9f1473d3c72

Regards,
	Matej Laitl
