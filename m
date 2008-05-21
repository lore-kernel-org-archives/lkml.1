Return-Path: <linux-kernel-owner+w=401wt.eu-S934802AbYEUGjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802AbYEUGjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbYEUGiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:38:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:37276 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbYEUGiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dlTONjt95Uic9f5xc3iAFRxFualZ5wx71VEQwNBqu14p6aVmlaTkRdnke2ktY06XWV0uuW363OlsuHGuprAS/NpLil8hMjwf4SV6Gb91KIYND5WO9EDGa9rxbVTz55eSk7rRYxcrozck2psyhDU7qrW5xv0J77WJc7J1KQVXAdA=
Message-ID: <386072610805202338q620eb980xb91273d4390d01a9@mail.gmail.com>
Date: Wed, 21 May 2008 14:38:48 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Javier Herrero" <jherrero@hvsistemas.es>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4833B717.5030005@hvsistemas.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080520073556.GA1090@flint.arm.linux.org.uk>
	 <483286AF.2090302@hvsistemas.es>
	 <20080520083217.GA10172@flint.arm.linux.org.uk>
	 <4832AD84.6090300@hvsistemas.es>
	 <20080520231323.GA10750@flint.arm.linux.org.uk>
	 <4833B717.5030005@hvsistemas.es>
X-Google-Sender-Auth: 532c4d44784b9fc9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:45 PM, Javier Herrero <jherrero@hvsistemas.es> wrote:
> Perhaps then, at least for now, in order to quickly restore the
> functionality of the driver with other platforms and to continue having the
> 8250 support in the blackfin, would be to apply this patch, that is a bit
> ugly but at least only affects to blackfin platforms using 8250-class uarts
> :)
>

IMO, we need to revert this 8250 irq patch. Can we fix this just in
Blackfin code?
I found it was specific for our arch not for others.

-Bryan



> Regards,
>
> Javier
>
> Russell King escribió:
>>
>> On Tue, May 20, 2008 at 12:52:52PM +0200, Javier Herrero wrote:
>>>
>>> I see... would be OK to move the asm/serial.h include to its original
>>> position and to modify the asm-blackfin/serial.h in this way to avoid
>>> duplicate definition warnings, or would it be too ugly?:
>>
>> Can blackfin systems accept PCMCIA cards?  Or PCI cards?  In which case
>> you probably don't want to implement this support like this.
>>
>> A better solution may be to add some UPF_ flags to indicate the interrupt
>> polarity on a per-port basis.  Not sure I'm particularly thrilled by that
>> idea though, but other solutions I can think of inspire me even less.
>>
>
> --
> ------------------------------------------------------------------------
> Javier Herrero                            EMAIL: jherrero@hvsistemas.com
> HV Sistemas S.L.                          PHONE:         +34 949 336 806
> Los Charcones, 17A                        FAX:           +34 949 336 792
> 19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
