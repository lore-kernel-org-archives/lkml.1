Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0CKV2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:28:55 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:53417 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0CKV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WsC/IsZ08yDRUd/4qOu9MMygUojEX4tUj8+Z+IHKBBAPKb3nU2dpfcgv+PDGy1QI+M
         li7UJ6PSmcrc354lV98PVJ1K4o9PYGDqrHn+yIfykqERtrauDUk2KwvZkn/DutyJa9gY
         yJJxhgc0cuhq/lqeb9LlboNHkTk3W7XFIqo38=
MIME-Version: 1.0
Date: Thu, 11 Mar 2010 22:28:50 +0100
Message-ID: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Fabio Comolli <fabio.comolli@gmail.com>
To: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentin.chary@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Mar 9, 2010 at 11:58 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi.
> I have an EeePC 900 running 2.6.34-rc1.
>
> If I boot it on AC the cpu runs at full speed, 900MHz; if I boot it on
> battery it runs only at 630Mhz. Plugging / unplugging the AC does not
> change the cpu frequency. Only a reboot can change the situation.
>
> I already tried to echo 0 or 1 to the
> /sys/devices/platform/eeepc/cpufv file; no effects, even if the file
> changes its value.
>
> This is not a regression from 2.6.33: this behavior is also present in
> that version.
>
> Does this ring any bells? This is really annoying, especially when
> trying to watch a movie on battery. Also 3D apps show a 30%
> performance drop, as expected.
>
> Regards,
> Fabio

Well, it turns out that this is indeed a regression, but I don't know
from which kernel version.
I reverted (not cleanly) this patch:

        http://patchwork.kernel.org/patch/28591

and now

        echo 1 > /sys/devices/platform/eeepc/cpufv

enables the powersave mode and

        echo 0 > /sys/devices/platform/eeepc/cpufv

enables the performance mode.

Tested with the non-benchmark glxgears (275 frames/sec in powersave
mode and 405 in performance mode) and stellarium (14 frames and 20
frames).

Regards,
Fabio
