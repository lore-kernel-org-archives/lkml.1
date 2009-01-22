Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZAVXHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZAVXHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758599AbZAVXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:06:30 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:41784 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612AbZAVXG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:28 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Philipp Kohlbecher <xt28@gmx.de>
Subject: Re: [PATCH] Make PNP IDs all uppercase
Date: Thu, 22 Jan 2009 23:03:38 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Pau Oliva Fora <pof@eslack.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Jaroslav Kysela <perex@perex.cz>, Adam Belay <abelay@mit.edu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
References: <49733678.40006@gmx.de>
In-Reply-To: <49733678.40006@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901222303.41737.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Thu, 22 Jan 2009 23:03:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009 14:02:32 Philipp Kohlbecher wrote:
> If I understand correctly, ACPI _HIDs (including PNP IDs) should be all
> uppercase, including the hex digits, cf. ACPI Specification 3.0b [1],
> pp. 162-3 and acpi_glb_hex_to_ascii[] in drivers/acpi/utilities/utglobal.c.

ACPI-WMI violates the spec here.

> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 8a8b377..79b8af7 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -84,7 +84,7 @@ static int acpi_wmi_add(struct acpi_device *device);
>
>   static const struct acpi_device_id wmi_device_ids[] = {
>   	{"PNP0C14", 0},
> -	{"pnp0c14", 0},
> +	{"PNP0C14", 0},
>   	{"", 0},
>   };
>   MODULE_DEVICE_TABLE(acpi, wmi_device_ids);
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 8473fe5..18c9335 100644

NAK to the ACPI-WMI changes. There really is a pnp0c14 and a PNP0C14, and 
removing the lower case version breaks ACPI-WMI on my laptop.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
