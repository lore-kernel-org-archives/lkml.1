Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbYLYR6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbYLYR6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYLYR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:58:34 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:37341 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYLYR6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:58:33 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Krzysztof =?utf-8?q?Kosi=C5=84ski?=" <tweenk.pl@gmail.com>
Subject: Re: [PATCH] tc1100-wmi: fix state reporting
Date: Thu, 25 Dec 2008 17:58:20 +0000
User-Agent: KMail/1.10.1 (Linux/2.6.27.7; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
References: <298610bb0812241845h41f5f916p73f85c64367ed8c@mail.gmail.com> <200812250755.39288.carlos@strangeworlds.co.uk> <298610bb0812250530r4661cbfaof88ba9d3946e744f@mail.gmail.com>
In-Reply-To: <298610bb0812250530r4661cbfaof88ba9d3946e744f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812251758.21371.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Thu, 25 Dec 2008 17:58:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, please apply.

On Thursday 25 December 2008 13:30:46 Krzysztof Kosiński wrote:
> (Resend)
> This small patch fixes the state reported when reading the files in
> /sys/devices/platofrm/tc1100-wmi/*. The first change fixes always
> returning 0 from the files in sysfs. The second one fixes jogdial
> state reporting to match with the commands used to set it (e.g. now
> after "echo 0 > /sys/devices/platofrm/tc1100-wmi/jogdial", "cat
> /sys/devices/platofrm/tc1100-wmi/jogdial" will return 0 instead of 1).
> Fixes bug #12286.
>
> Signed-off-by: Krzysztof Kosiński <tweenk.pl@gmail.com>

Cc: stable@kernel.org
Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

>
> --- linux-2.6.27/drivers/misc/tc1100-wmi.c      2008-10-10
> 00:13:53.000000000 +0200
> +++ linux/drivers/misc/tc1100-wmi.c     2008-12-25 02:58:48.000000000 +0100
> @@ -95,9 +95,8 @@
>                return -ENODEV;
>
>        obj = (union acpi_object *) result.pointer;
> -       if (obj && obj->type == ACPI_TYPE_BUFFER &&
> -               obj->buffer.length == sizeof(u32)) {
> -               tmp = *((u32 *) obj->buffer.pointer);
> +       if (obj && obj->type == ACPI_TYPE_INTEGER) {
> +               tmp = obj->integer.value;
>        } else {
>                tmp = 0;
>        }
> @@ -110,7 +109,7 @@
>                *out = (tmp == 3) ? 1 : 0;
>                return 0;
>        case TC1100_INSTANCE_JOGDIAL:
> -               *out = (tmp == 1) ? 1 : 0;
> +               *out = (tmp == 1) ? 0 : 1;
>                return 0;
>        default:
>                return -ENODEV;

-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
