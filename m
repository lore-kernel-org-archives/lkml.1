Return-Path: <linux-kernel-owner+w=401wt.eu-S1763262AbXGFJrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262AbXGFJrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbXGFJrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:47:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:62805 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907AbXGFJrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sJX76GO4qzzU1zJMqRjRetGKGeqeuZW7oy0URKNVTxaMQ6AO+V3b0rkCWbR3Iit6NapqF0h44D7NMRqePkeNcMI6k/BzFQNAZO4yprTzy9N5oM/VN6b3KyLZ0g0gjQ0wfxp6+H2u8TxmpPHPs0eigBXfSF4yrZrFogWL/10VPv8=
Message-ID: <92a12cdb0707060246p407f19depe16c59ac43eb0d96@mail.gmail.com>
Date: Fri, 6 Jul 2007 10:46:59 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA AICA sound on SEGA Dreamcast - fix behaviour in poor resource conditions
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5h3b016fzx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707051507r7ab1516blb7ea755d89c25efa@mail.gmail.com>
	 <s5h3b016fzx.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 5 Jul 2007 23:07:44 +0100,
> Adrian McMenamin wrote:
> > @@ -402,17 +396,10 @@
> >  static int snd_aicapcm_pcm_trigger(struct snd_pcm_substream
> >                                  *substream, int cmd)
> >  {
> > -     struct snd_card_aica *dreamcastcard;
> >       switch (cmd) {
> >       case SNDRV_PCM_TRIGGER_START:
> >               spu_begin_dma(substream);
> >               break;
> > -     case SNDRV_PCM_TRIGGER_STOP:
> > -             dreamcastcard = substream->pcm->private_data;
> > -             if (dreamcastcard->timer.data)
> > -                     del_timer(&dreamcastcard->timer);
> > -             aica_chn_halt();
> > -             break;
> >       default:
> >               return -EINVAL;
> >       }
>
> Is this a correct change?  Then you'd have no control for stopping the
> stream.
>

The shutdown is all done in the close() now, partly because
snd_aicapcm_pcm_trigger cannot sleep and close() can. Is there a
pressing reason to put code in snd_aicapcm_pcm_trigger?
