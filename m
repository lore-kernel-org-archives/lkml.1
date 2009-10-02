Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZJBHvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZJBHvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZJBHvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:51:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51328 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZJBHvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:51:11 -0400
Message-ID: <4AC5B0F1.4030303@canonical.com>
Date: Fri, 02 Oct 2009 09:51:13 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Peter Feuerer <peter@piie.net>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: Limit modalias matching to supported boards
References: <4AC34B83.6090402@canonical.com> <20090930212233.GB17712@liondog.tnic> <cone.1254466252.404216.3290.1000@onepiie>
In-Reply-To: <cone.1254466252.404216.3290.1000@onepiie>
Content-Type: multipart/mixed;
 boundary="------------000508040502030006070803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508040502030006070803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Peter Feuerer wrote:
> Borislav Petkov writes:
> 
>> On Wed, Sep 30, 2009 at 02:13:55PM +0200, Stefan Bader wrote:
>>> We got reports of acerhdf issuing warnings on Acer laptops other
>>> than Aspire Ones. Looking at the dmi match this sounds a bit to
>>> generic. IOW the module gets loaded on any Acer laptop. After the
>>> following patch the module gets still loaded on my Aspire One but
>>> not on the reported other laptop.
>>> The same change might be helpful for the other two dmi matches, but
>>> I had no way of testing.
>>
>> Yeah, we might need someone with such a machine to give us
>> /sys/class/dmi/id/modalias content. Peter, do you have any users with
>> such machines?
> 
> I search my acerhdf-inbox for the people who sent me the BIOS versions, 
> maybe they still have the netbook and can me send the modalias content. 
> I'll hopefully find some time upcoming weekend.
> 
> But, can't we simply assume, following dmi lines?
> 
> MODULE_ALIAS("dmi:*:*Acer*:*AOA*:");
> MODULE_ALIAS("dmi:*:*Gateway*:*AOA*:");
> MODULE_ALIAS("dmi:*:*Packard Bell*:*AOA*:");
> MODULE_ALIAS("dmi:*:*Packard Bell*:*DOA*:");
> 
> We have exactly those constellations within the BIOS settings table. If 
> I interpret the modalias line correctly, "pnAOA110" means "Product Name 
> AOA110" and that's what we have already in the BIOS settings table. So I 
> think we do already have all information we need to create a complete 
> patch for the problem, or am I wrong?

Right pn means that. I would strongly believe the above changes should be good. 
I sometimes tend to be over-cautious. Attaching a refreshed patch which 
includes them all.

-Stefan

>>
>>> From 389f61f7e66ce615dc6418cb856e167edaa74b42 Mon Sep 17 00:00:00 2001
>>> From: Stefan Bader <stefan.bader@canonical.com>
>>> Date: Mon, 28 Sep 2009 17:11:29 +0000
>>> Subject: [PATCH] UBUNTU: acerhdf: Limit modalias matching to 
>>> supported boards
>>>
>>> BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958
>>>
>>> The module alias currently matches any Acer computer but when loaded the
>>> BIOS checks will only succeed on Aspire One models. This causes a 
>>> invalid
>>> BIOS warning for all other models (seen on Aspire 4810T).
>>> This is not fatal but worries users that see this message. Limiting the
>>> moule alias to models starting with AOA. Probably the same change 
>>> should be
>>> made for the two other entries.
>>>
>>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>>
>> Acked-by: Borislav Petkov <petkovbb@gmail.com>
>>
>>> ---
>>>  drivers/platform/x86/acerhdf.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/platform/x86/acerhdf.c 
>>> b/drivers/platform/x86/acerhdf.c
>>> index aa298d6..763f233 100644
>>> --- a/drivers/platform/x86/acerhdf.c
>>> +++ b/drivers/platform/x86/acerhdf.c
>>> @@ -629,7 +629,7 @@ static void __exit acerhdf_exit(void)
>>>  MODULE_LICENSE("GPL");
>>>  MODULE_AUTHOR("Peter Feuerer");
>>>  MODULE_DESCRIPTION("Aspire One temperature and fan driver");
>>> -MODULE_ALIAS("dmi:*:*Acer*:*:");
>>> +MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
>>>  MODULE_ALIAS("dmi:*:*Gateway*:*:");
>>>  MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
>>>  
>>> -- 
>>> 1.5.4.5
> 
> kind regards,
> --peter


-- 

When all other means of communication fail, try words!



--------------000508040502030006070803
Content-Type: text/x-diff;
 name="0001-acerhdf-Limit-modalias-matching-to-supported-boards.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-acerhdf-Limit-modalias-matching-to-supported-boards.pat";
 filename*1="ch"

>From 60cdb7bea856fdd594262ee1e9608cd2210cf196 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Mon, 28 Sep 2009 17:11:29 +0000
Subject: [PATCH] acerhdf: Limit modalias matching to supported boards

BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958

The module alias currently matches any Acer computer but when loaded the
BIOS checks will only succeed on Aspire One models. This causes a invalid
BIOS warning for all other models (seen on Aspire 4810T).
This is not fatal but worries users that see this message. Limiting the
moule alias to models starting with AOA or DOA for Packard Bell.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/platform/x86/acerhdf.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 0a8f735..23eea4c 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -629,9 +629,10 @@ static void __exit acerhdf_exit(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
-MODULE_ALIAS("dmi:*:*Acer*:*:");
-MODULE_ALIAS("dmi:*:*Gateway*:*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
-- 
1.5.4.3


--------------000508040502030006070803--
