Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXE3LsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXE3LsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbXE3Lrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:47:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:40786 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbXE3Lrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nVOBQPqY+9XsW9NCt6OFKpcklUFdvo+4ZaLY2A8xzu3MYlOi3i5eOZrdyQdacicgM1fskhEUoVZzLrwMdYCXPAamSMtEx8tbDF/ff2IwCVCMa2OMgieZidXK4Y9Kp6m09XH+QTjQLDAIgW2CQd7h0KiTS45N9u1JgCClClBSv2M=
Message-ID: <465D6460.6030003@gmail.com>
Date: Wed, 30 May 2007 13:47:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Bill Nottingham <notting@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alsa: fix comparison of unsigned < 0
References: <20070530073554.GA28809@nostromo.devel.redhat.com> <s5h7iqqhb09.wl%tiwai@suse.de>
In-Reply-To: <s5h7iqqhb09.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai napsal(a):
> Hi,
> 
> thanks for checking this.
> They seem actually hitting some real bugs.

Bug fixes are ok, but keep on your mind this (I haven't checked if this is
the case):
http://lkml.org/lkml/2006/11/28/206

> At Wed, 30 May 2007 03:35:54 -0400,
> Bill Nottingham wrote:
>> diff -ru linux-2.6.21-old/sound/pci/ac97/ac97_patch.c linux-2.6.21/sound/pci/ac97/ac97_patch.c
>> --- linux-2.6.21-old/sound/pci/ac97/ac97_patch.c	2007-05-30 02:53:05.000000000 -0400
>> +++ linux-2.6.21/sound/pci/ac97/ac97_patch.c	2007-05-30 02:32:41.000000000 -0400
>> @@ -2086,8 +2086,7 @@
>>  	struct snd_ac97 *ac97 = snd_kcontrol_chip(kcontrol);
>>  	unsigned short val;
>>  
>> -	if (ucontrol->value.enumerated.item[0] > 3
>> -	    || ucontrol->value.enumerated.item[0] < 0)
>> +	if (ucontrol->value.enumerated.item[0] > 3)
>>  		return -EINVAL;
>>  	val = ctrl2reg[ucontrol->value.enumerated.item[0]]
>>  	      << AC97_AD198X_VREF_SHIFT;
> 
> This one is fine.
[...]

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
