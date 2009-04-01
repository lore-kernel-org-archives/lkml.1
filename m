Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbZDARNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbZDARNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbZDARN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:13:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:29263 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391AbZDARN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZwShbCi+g246yNK/9/uOpIhGuG7B+4YzEZAaXnFfl5M328bvkugEmbipsb+n4m02RX
         isbTFo6askOeCgU1X/ZOhUJak8wOtN+I/GPGUJ515QPEBBXbPktXVOtxAjkcWoEO5esJ
         UAhLeYv/nkuu+/y6Ut+sjVwQEqRAODBWGdx/o=
MIME-Version: 1.0
In-Reply-To: <20090401170708.GA14167@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org>
	 <20090331214749.GD29489@srcf.ucam.org>
	 <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
	 <20090331221107.GA30383@srcf.ucam.org>
	 <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com>
	 <20090331230217.GA31599@srcf.ucam.org>
	 <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com>
	 <20090401165345.GA13939@srcf.ucam.org>
	 <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com>
	 <20090401170708.GA14167@srcf.ucam.org>
Date: Thu, 2 Apr 2009 10:13:23 +1700
Message-ID: <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 10:07 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Apr 02, 2009 at 10:03:05AM +1700, Azael Avalos wrote:
>> On Thu, Apr 2, 2009 at 9:53 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > Yes, you shouldn't be reading directly from TOHK at any point. It seems
>> > to be a purely internal variable - I'm fairly sure that the INFO method
>> > is the only one that should be called on event generation.
>>
>> Well, on the patches sent to the omnibook module I was polling TOHK directly,
>> it is until now that I realized that I can poll the events via INFO
>> method, that is,
>> if I enable TECF first via method \\_SB.PCI0.LPCB.EC0.NTFY
>
> Mm. None of the TOS1900 DSDTs I have here have TECF or NTFY methods, so
> again that doesn't sound like the right way of driving them. Does the
> ENAB method not do this?

At least not in my model, the ENAB method is empty, heres a snippet of the DSDT:

                            Method (ENAB, 0, NotSerialized)
                            {
                            }

                            Method (INFO, 0, NotSerialized)
                            {
                                If (TECF)
                                {
                                    Store (Zero, TECF)
                                    Store (^^PCI0.LPCB.EC0.TOHK, Local0)
                                    Store (Zero, ^^PCI0.LPCB.EC0.TOHK)
                                }
                                Else
                                {
                                    Store (Zero, Local0)
                                }

                                Return (Local0)
                            }

And above scope _SB you can find

                    Method (NTFY, 0, NotSerialized)
                    {
                        Store (One, ^^^^VALZ.TECF)
                        Notify (VALZ, 0x80)
                        Return (0xAA)
                    }

Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
