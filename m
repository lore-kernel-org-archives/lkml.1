Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbZHVJb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbZHVJb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 05:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZHVJb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 05:31:28 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44662 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZHVJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 05:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H/7xNEv/i0A5zlZpDt9rcLAOZHMFzH5ugAobaUMxO+9g8nLHJk6fdR6KDDTK22m95k
         3VmBrUrV0bGRCdUrfK4KYfTJbhCxF4VyJ7b+dXHzqc9xQ/4a9mH6sbv2lcAIT5vp3Du6
         BwwtgBWm3754dMVngdJprhJ162aMcrd9HoA3Q=
MIME-Version: 1.0
In-Reply-To: <4A8F1500.6070208@dell.com>
References: <1250706980-10424-1-git-send-email-Mario_Limonciello@Dell.com>
	 <9b2b86520908200217j6a62b19dk6214b827af34418@mail.gmail.com>
	 <4A8F1500.6070208@dell.com>
Date: Sat, 22 Aug 2009 10:31:27 +0100
Message-ID: <9b2b86520908220231v6d4ab9aahfe69914e5c5fb796@mail.gmail.com>
Subject: Re: [PATCH 3/3] Drop platform sysfs attributes from compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: cezary.jackiewicz@gmail.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Alan Jenkins wrote:
>> On 8/19/09, Mario Limonciello <Mario_Limonciello@dell.com> wrote:
>>
>> Don't you still need to call platform_device_del() for the fail_rfkill
>> case?
>>
>>
> It was previously only called if the sysfs attribute creation failed.
> So if it does need to be called, then there was a bug previously there too.

Nope, look at it again.

> @@ -481,11 +326,7 @@ static int __init compal_init(void)
>         return 0;
>
>   fail_rfkill:
>  -fail_platform_device2:
>  -
>  -       platform_device_del(compal_device);
>  -
>  -fail_platform_device1:
>  +fail_platform_device:
>
>         platform_device_put(compal_device);

Without this patch, fail_rfkill falls through to
fail_platform_device2, and calls platform_device_del().  With the
patch, the call to platform_device_del() is removed, so it will no
longer be called for the fail_rfkill case.  It's not a pre-existing
bug.

Regards
Alan
