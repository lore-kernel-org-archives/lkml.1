Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540Ab0AECPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0AECPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522Ab0AECPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:15:47 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:38614 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0AECPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cK00K6E/0KkDWzrVWk1M9mh+Gv1PfYrsDhX1uhaZvIDS1XVH0oCg5RoGfV1wytCSNl
         p/o+YQcLh7QUx2hvuvYvv++8JsINbIJ91pvHrEpb/CPEPj8tqK2HD/QrweFxOQrzVBjS
         koU5GhAH/vgv8g2ZL2UmKNfeRh6rUDBCu0A58=
Message-ID: <4B42A0CC.2090907@gmail.com>
Date: Mon, 04 Jan 2010 20:15:40 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christian Hofstaedtler <ch@zeha.at>,
       x86@kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <alpine.LFD.2.00.1001041632330.4012@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001041632330.4012@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 04:03 PM, Len Brown wrote:
>>> I believe that Venki is sending a patch to make all recent
>>> motherboards use acpi reset by default; and I'd rather
>>> see that kind of patch than this one.
>>>
>>> I've had the patch below patch in acpi-test, and thus linus-next,
>>> and -mm since Nov 2008 to change the default for
>>> all systems w/ no issues.
>>>
>>
>> Maybe I'm misremembering, but didn't we have to pull this patch after it
>> hit mainstream the last time?
>
>
> c7ffa6c26277b403920e2255d10df849bd613380
> "x86: default to reboot via ACPI"
>
> set ACPI as the default in 2.6.28-rc1
>
> 8d00450d296dedec9ada38d43b83e79cca6fd5a3
> Revert "x86: default to reboot via ACPI"
>
> pulled it in v2.6.28-rc4
>
> The original patch was justified by VMX support,
> and the revert was in response to Andrey Borzenkov's
> DMI patch to usee BIOS reset on his Toshiba Porgege 4000:
>
> http://lkml.org/lkml/2008/10/31/242
>
> The Toshiba Portege 4000 shipped in early 2002.
>
> The patch to restore ACPI reset to default has been in Linux-next
> (with occasional drops) since the day it was dropped from 2.6.28-rc4.
>
> As we have an existence proof, I have no doubt that using
> ACPI reset by default will un-earth some regressions.  However,
> my guess is that the DMI list of old machines that will fail
> with ACPI reset will be smaller than by the DMI list of
> brand-new machines that will fail without ACPI reset.
>
> We couuld use a DMI year cut-off as we do with
> ACPI itself CONFIG_ACPI_BLACKLIST_YEAR, though that
> doesn't work on systems that don't have DMI...
> If I were to propose a year, I'd say 2006 and newer,
> since XP was "Windows 2006".

Think you mean 2001, Vista was 2006..

I'm assuming that Windows is using ACPI reset these days, so presumably 
that's what we should be doing by default, and blacklisting machines 
where that doesn't work, rather than the reverse..
