Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbYBLMG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbYBLMG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYBLMGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:06:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:55854 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBLMGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rXennyXjN/m49AC4+qwKmSTOzKpDbKtiiQoyts892Wun8jVgnfJgJ4cvEUKeNZNwDSdP2a+Ts9rzKbj3slBfmmFalPOJQk2M50idX34GZDF9uzyrXQo5SBRMueMiXga7HtjyuOrHI9DqUIP0FtHxGIxIjCAbwaeBZuGeKkmKGLc=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Tue, 12 Feb 2008 13:06:08 +0100
User-Agent: KMail/1.9.7
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <s5h7ihav3nr.wl%tiwai@suse.de> <s5hzlu6tnl0.wl%tiwai@suse.de>
In-Reply-To: <s5hzlu6tnl0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802121306.08848.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> I wrote:
> > Thanks.  It seems that your device has two headphone jacks according
> > to the BIOS setup, and this seems to be the problem.
> >
> > Could you show the kernel messages like "autoconfig: line_outs..." for
> > both cases?  This appears when build with CONFIG_SND_DEBUG=y.
>
> And the patch below may fix your problem.  Give it a try.

With your patch, the sound in headphone-out is working again, but surprisingly 
the integrated loudspeakers stopped working! ;)

Also, new on/of control appeared in alsamixer - "Speaker", but unmuting it 
(and unmuting all playback controls, plugging-out headphones) didn't have an 
effect on non-working integrated loudspeakers.

Some kernel mesgs with your patch:
hda_codec: Unknown model for ALC262, trying auto-probe from BIOS...
autoconfig: line_outs=1 (0x1b/0x0/0x0/0x0/0x0)
   speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
   hp_outs=1 (0x15/0x1b/0x0/0x0/0x0)
   mono: mono_out=0x0
   inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0

alsa-info.sh output:
http://pastebin.ca/901089

Matej
