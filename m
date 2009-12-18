Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZLRMVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZLRMVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZLRMVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:21:30 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56501 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZLRMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CYe8HjphK0ym651279kTFzEkcvOAQCX2TiWwnoqjfaeLwr6mbuzeZRbHJStnV8KCjZ
         5OSUzFt4//D9DBCZBHKigFYi8mIZdVwJEXuV/nIGIihYjtG+3u09OG06Zd6yuozcI+G2
         p1PCE+GmvLrlmCJS0OkYGFDiEVFBi7ZM7Ccto=
Message-ID: <4B2B743B.7010004@gmail.com>
Date: Fri, 18 Dec 2009 20:23:23 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org
Subject: Re: [Patch] thinkpad_acpi: fix a build error
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>	<7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com> <s5hhbrowpty.wl%tiwai@suse.de>
In-Reply-To: <s5hhbrowpty.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 18 Dec 2009 17:42:34 +0800,
> Xiaotian Feng wrote:
>   
>> Ingo already sent this patch yesterday.
>> http://lkml.org/lkml/2009/12/17/25
>>
>>
>> On Fri, Dec 18, 2009 at 5:28 PM, Amerigo Wang <amwang@redhat.com> wrote:
>>     
>>> This patch fixes the following build error:
>>>
>>>  Building modules, stage 2.
>>>  MODPOST 1834 modules
>>> ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>> ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>> ERROR: "snd_ctl_boolean_mono_info" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>> ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>> ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>> ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>> ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>>
>>> Cc: Len Brown <len.brown@intel.com>
>>> Cc: Corentin Chary <corentincj@iksaif.net>
>>> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>>> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>>> Reported-by: Helight.Xu <helight.xu@gmail.com>
>>> Signed-off-by: WANG Cong <amwang@redhat.com>
>>> Tested-by: Helight.Xu <helight.xu@gmail.com>
>>>
>>> ---
>>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
>>> index fc5bf9d..596966c 100644
>>> --- a/drivers/platform/x86/Kconfig
>>> +++ b/drivers/platform/x86/Kconfig
>>> @@ -215,6 +215,7 @@ config THINKPAD_ACPI
>>>        depends on ACPI
>>>        depends on INPUT
>>>        depends on RFKILL || RFKILL = n
>>> +       depends on SOUND
>>>       
>
> The patch isn't correct (I guess the upstream fix is same?).
>
> CONFIG_SOUND is a global config for sound subsystem.  The relevant
> functions are ALSA core part, which is CONFIG_SND.
> So, the fix should be:
>
> 	depends on SND
>   
yes, I think so ! It should be "depends on SND", and I am testing now!
> instead.
>
>
> Takashi
>
>   


-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

