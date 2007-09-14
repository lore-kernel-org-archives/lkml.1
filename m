Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXINTfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXINTfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXINTfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:35:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:23987 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbXINTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Hr49QpBMMk0jYVwDRbDSQ3ufniFt0SIZHIbvsw2xwNFgKL2PXocSMWblb67lwPv3PQWswae+rxZxIb/Gs5guMIa5DDjBU53Pe9ounvruJAJ8VJJhEa4JUAOf4/YKN9StjU1QZ6x/BXWp6u84QUCUqEGpIog7rGm5023DSVS22rw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
Date: Fri, 14 Sep 2007 20:34:59 +0100
User-Agent: KMail/1.9.1
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <200709141848.06027.vda.linux@googlemail.com> <1189793347.19708.156.camel@localhost>
In-Reply-To: <1189793347.19708.156.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709142034.59802.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2007 19:09, Joe Perches wrote:
> On Fri, 2007-09-14 at 18:48 +0100, Denys Vlasenko wrote:
> 
> > Patch is attached.
> 
> The SND_HDA_PRESETS define doesn't seem useful.
> It's only used once.

It is defined in .h file and used in .c file.

It is made so because defining static data variables in .h file
is a bad style in general and in this case will result in build-time
warnings in particular.

Therefore definition of hda_preset_tables[] is moved to .c file.

It looks like this:

static const struct hda_codec_preset *const hda_preset_tables[] = {
       snd_hda_preset_realtek,
       snd_hda_preset_cmedia,
       snd_hda_preset_analog,
       snd_hda_preset_sigmatel,
       snd_hda_preset_si3054,
       snd_hda_preset_atihdmi,
       snd_hda_preset_conexant,
       snd_hda_preset_via,
       NULL
};

I want to make it easier for people to add new snd_hda_preset_XXX.

I don't want them to be forced to add it in hda_patch.h first,
and then go to hda_codec.c and add it there too.

Therefore I turned this list into a #define which sits in hda_patch.h:

#define SND_HDA_PRESETS \
       snd_hda_preset_realtek, \
       snd_hda_preset_cmedia, \
       snd_hda_preset_analog, \
       snd_hda_preset_sigmatel, \
       snd_hda_preset_si3054, \
       snd_hda_preset_atihdmi, \
       snd_hda_preset_conexant, \
       snd_hda_preset_via

Now if you want to add yet another snd_hda_preset_XXX, you
don't need to touch hda_codec.c.

Original code was achieving the same by cheating: it has

static const struct hda_codec_preset *hda_preset_tables[] = {...}

in hda_patch.h.
--
vda
