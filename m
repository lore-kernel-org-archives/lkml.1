Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbXJROWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbXJROWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbXJROWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:22:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:3349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXJROWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gIlpqavQY5Mc9GPbxD+22xh/qWr9aBKAh2EGyOtNIyWtuONwTPs8meGvS1R7OKuPduSudixFE+R+FZIvg5A0S0NiFX20hnuJiUtP+bkfOBl0DWQFeH/CMbFvolDdteJPI9HMnq105HJ5cINizK3uv+M2f2cC2hKM5T2kipZ6H+s=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 16:21:59 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <471538C2.80806@m3y3r.de> <200710180353.08638.maximlevitsky@gmail.com> <s5hd4vdc6d4.wl%tiwai@suse.de>
In-Reply-To: <s5hd4vdc6d4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181621.59795.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 07:57:27 Takashi Iwai wrote:
> At Thu, 18 Oct 2007 03:53:08 +0200,
> Maxim Levitsky wrote:
> > 
> > From 0824b077b75c19253b45c5a455775c331acd54ee Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Thu, 18 Oct 2007 03:35:37 +0200
> > Subject: [PATCH] [HDA] [STAC] Since there is now a master volume control,
> > don't call the headphone output "Master", it isn't strictly correct anyway
> 
> I thought stac925x has no volume knob, so "Master" should be still
> applied for this codec?

Yes, you are right, but stac925x has only one DAC, and thus if it is connected to any line-out, it will be
'Front', but if it is connected to 'headphones' only, then why not to call it 'Headphone'

STAC  9200 has no volumeknob too, but it is handled seperartly
STAC  9202 and 9250 has no volumeknob too, but as I said they have just one DAC again


Best regards,
	Maxim Levitsky
> 
> 
> Takashi
> 
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  pci/hda/patch_sigmatel.c |    7 +------
> >  1 files changed, 1 insertions(+), 6 deletions(-)
> > 
> > diff --git a/pci/hda/patch_sigmatel.c b/pci/hda/patch_sigmatel.c
> > index 6dffa54..7f157a6 100644
> > --- a/pci/hda/patch_sigmatel.c
> > +++ b/pci/hda/patch_sigmatel.c
> > @@ -1907,12 +1907,7 @@ static int stac92xx_auto_create_hp_ctls(struct hda_codec *codec,
> >  			return err;
> >  	}
> >  	if (spec->multiout.hp_nid) {
> > -		const char *pfx;
> > -		if (old_num_dacs == spec->multiout.num_dacs)
> > -			pfx = "Master";
> > -		else
> > -			pfx = "Headphone";
> > -		err = create_controls(spec, pfx, spec->multiout.hp_nid, 3);
> > +		err = create_controls(spec, "Headphone", spec->multiout.hp_nid, 3);
> >  		if (err < 0)
> >  			return err;
> >  	}
> > -- 
> > 1.5.3.4
> > 
> 


