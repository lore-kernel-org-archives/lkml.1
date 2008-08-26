Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYHZVLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYHZVLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYHZVK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:10:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:36312 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYHZVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z/d895xxnqt45Ej5kq0fiqkC5GcuBSpZq4iDguSl7lSgPdMMjKrmqtwNdCJ2RHFR/v
         roADNLX/8bhL/Wijsd0lHK92vOjOU/j5wq5HRuaGcmzZup9yX3GmPHlFuR2KzuGvUS29
         G7AdiF4EOM8TXvF8SB+Er3cyG3iorfirF/yW4=
Message-ID: <3d8471ca0808261410t791c3627s9e3f9d82b1a7093@mail.gmail.com>
Date: Tue, 26 Aug 2008 23:10:55 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [ALSA PATCH] alsa-git merge request
Cc: "Jaroslav Kysela" <perex@perex.cz>, "Travis Place" <wishie@wishie.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "ALSA development" <alsa-devel@alsa-project.org>
In-Reply-To: <s5hwsi42u66.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>
	 <3d8471ca0808241430p2e3fbb85g63f1340512339d31@mail.gmail.com>
	 <s5hiqtpd4nb.wl%tiwai@suse.de>
	 <3d8471ca0808251436q5742fb09t9291362669870fb3@mail.gmail.com>
	 <3d8471ca0808251543x7ce782e2n52b31ae306d45ec6@mail.gmail.com>
	 <s5hwsi42u66.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 7:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Are you sure both are the same kernel but just one commit reverted?

I retested, yes.
With or without the revert, model=auto disables sound completely, and
I get this in dmesg:

HDA Intel 0000:00:1b.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA /home/g/linux-2.6/sound/pci/hda/hda_codec.c:2325: hda_codec:
model 'auto' is selected
ALSA /home/g/linux-2.6/sound/pci/hda/hda_codec.c:3021: autoconfig:
line_outs=1 (0x14/0x0/0x0/0x0/0x0)
ALSA /home/g/linux-2.6/sound/pci/hda/hda_codec.c:3025:
speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA /home/g/linux-2.6/sound/pci/hda/hda_codec.c:3029:    hp_outs=1
(0x15/0x0/0x0/0x0/0x0)
ALSA /home/g/linux-2.6/sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
ALSA /home/g/linux-2.6/sound/pci/hda/hda_codec.c:3038:    inputs:
mic=0x18, fmic=0x0, line=0x1a, fline=0x0, cd=0x0, aux=0x0

I played with model=intel-mac-auto and model=intel-mac-v3 but it had
no effect, i.e. same as without the model= parameter.

So, without model=auto the problem is that I get the output on both
the internal speakers and the headphones, and this is fixed by
reverting the commit.

Thanks.

-- 
Guillaume
