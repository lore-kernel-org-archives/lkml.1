Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZJBJyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZJBJyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZJBJyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:54:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:53548 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbZJBJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wBSTRnTjqirKa9IIiSZAx8LcxiqvyMPyCoY1Ozp2UW6B+MEmKvsFFMtVjGa8hZSG3q
         6vbllod/jR8PHAKRk5iNxT6JGjCP60ywuYdakyAKm+G1uyWrCqoL9lzXtZm2/5XJWMpw
         JNE1Bbhn2wTYuMZifLepNN0IA7hfhtsT3nmjY=
MIME-Version: 1.0
In-Reply-To: <4AC5B0F1.4030303@canonical.com>
References: <4AC34B83.6090402@canonical.com>
	 <20090930212233.GB17712@liondog.tnic>
	 <cone.1254466252.404216.3290.1000@onepiie>
	 <4AC5B0F1.4030303@canonical.com>
Date: Fri, 2 Oct 2009 11:54:56 +0200
Message-ID: <9ea470500910020254j21fad1d3g1c825bcecdbb29fb@mail.gmail.com>
Subject: Re: [PATCH] acerhdf: Limit modalias matching to supported boards
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 9:51 AM, Stefan Bader <stefan.bader@canonical.com> wrote:
>>> I search my acerhdf-inbox for the people who sent me the BIOS versions,
>> maybe they still have the netbook and can me send the modalias content. I'll
>> hopefully find some time upcoming weekend.
>>
>> But, can't we simply assume, following dmi lines?
>>
>> MODULE_ALIAS("dmi:*:*Acer*:*AOA*:");
>> MODULE_ALIAS("dmi:*:*Gateway*:*AOA*:");
>> MODULE_ALIAS("dmi:*:*Packard Bell*:*AOA*:");
>> MODULE_ALIAS("dmi:*:*Packard Bell*:*DOA*:");
>>
>> We have exactly those constellations within the BIOS settings table. If I
>> interpret the modalias line correctly, "pnAOA110" means "Product Name
>> AOA110" and that's what we have already in the BIOS settings table. So I
>> think we do already have all information we need to create a complete patch
>> for the problem, or am I wrong?
>
> Right pn means that. I would strongly believe the above changes should be
> good. I sometimes tend to be over-cautious. Attaching a refreshed patch
> which includes them all.

Well, acerhdf.c and dmi-id.c both do
dmi_get_system_info(DMI_PRODUCT_NAME) when querying product name which
means that the product names in the acerhdf table and the dmi-id ones
are actually one and the same thing.

IMO, we should just go ahead send it to Len. Stefan, you have my ACK.

-- 
Regards/Gruss,
Boris
