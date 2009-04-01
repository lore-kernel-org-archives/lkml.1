Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZDARDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZDARDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbZDARDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:03:11 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45800 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbZDARDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lSYP0EsiO3HGH4lUbWeVxV3kLZesgGn/Rf5kqkoRdz/7/flvco/0KTm9AZujedH1rD
         ckJzAH5Vr3tDTMVa5XXLkwL4l4mgan4woiY2PYB53eShEC5ibOEUsIlM12IeEdBj4v27
         WBw7rFjwW+8S/KREKVegclmKKIS5of4BgLkeY=
MIME-Version: 1.0
In-Reply-To: <20090401165345.GA13939@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org>
	 <20090331214749.GD29489@srcf.ucam.org>
	 <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
	 <20090331221107.GA30383@srcf.ucam.org>
	 <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com>
	 <20090331230217.GA31599@srcf.ucam.org>
	 <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com>
	 <20090401165345.GA13939@srcf.ucam.org>
Date: Thu, 2 Apr 2009 10:03:05 +1700
Message-ID: <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com>
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

On Thu, Apr 2, 2009 at 9:53 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Apr 02, 2009 at 09:50:59AM +1700, Azael Avalos wrote:
>> On Wed, Apr 1, 2009 at 4:02 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > Ok, can you try this and let me know what codes it generates (if it
>> > generates any)? It should go on top of the previous patches.
>>
>> Nothing gets generated, even if I change the method to ".INFO" and hotkey
>> events enabled with hci_write2(HCI_HOTKEY_EVENT, 1, 1, &hci_result) and
>> TECF set to 1 (see my DSDT).
>>
>> I was playing with the code yesterday trying to get some events reported, but no
>> luck so far.
>>
>> It appears that TOHK variable is _volatile_ and it just stores hotkey events
>> temporarily and they don't get _stored_ like in the System Event FIFO.
>
> Yes, you shouldn't be reading directly from TOHK at any point. It seems
> to be a purely internal variable - I'm fairly sure that the INFO method
> is the only one that should be called on event generation.

Well, on the patches sent to the omnibook module I was polling TOHK directly,
it is until now that I realized that I can poll the events via INFO
method, that is,
if I enable TECF first via method \\_SB.PCI0.LPCB.EC0.NTFY

>
>> On the patches I sent to the omnibook module I'm able to get events but they
>> seem to get repeated 3 times, or perhaps I'm polling to often.
>
> Hm. I don't have test hardware right now, I'm afraid. I'll look at some
> DSDTs a bit more and see if anything springs to mind.

Well, I brought my laptop to work (I'm a sysadmin so I got plenty of time :-P)
and I can test if that helps

>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
