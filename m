Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZLZUTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZLZUTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 15:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZLZUTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 15:19:13 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:41002 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZLZUTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 15:19:12 -0500
Date: Sat, 26 Dec 2009 15:19:10 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -tip: origin tree boot crash
In-reply-to: <20091225194935.GA23802@core.coreip.homeip.net>
Message-id: <alpine.LFD.2.00.0912261518400.4089@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <20091225194935.GA23802@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dell-wmi - fix condition to abort driver loading


applied to acpi-test

thanks,
-Len Brown, Intel Open Source Technology Center

> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> The commit 1fdd407f4e3f2ecb453954cbebb6c22491c61853 incorrectly made driver
> abort loading when known GUID is present when it should have done exactly
> the opposite.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/platform/x86/dell-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
> index 916ccb2..c980782 100644
> --- a/drivers/platform/x86/dell-wmi.c
> +++ b/drivers/platform/x86/dell-wmi.c
> @@ -324,7 +324,7 @@ static int __init dell_wmi_init(void)
>  {
>  	int err;
>  
> -	if (wmi_has_guid(DELL_EVENT_GUID)) {
> +	if (!wmi_has_guid(DELL_EVENT_GUID)) {
>  		printk(KERN_WARNING "dell-wmi: No known WMI GUID found\n");
>  		return -ENODEV;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
