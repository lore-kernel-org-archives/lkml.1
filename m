Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYAKOrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYAKOrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbYAKOrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:47:20 -0500
Received: from hu-out-0506.google.com ([72.14.214.234]:51784 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760782AbYAKOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sO6HrLwaP5TOwCd4MV6fvO6q/k/HZ1l3PqssKmTvV1UvkWZJan96G0xDVp985UTQnD4OekKP3tMMRfvOjqzhBtHMp1ypSE6d3Q30hGEjxsJGKxc8SLKa8fuyFf521KOd+9mAUHxgZ2WfScwMouunGR5SSHLNAED/Hq/SlTZERRc=
Message-ID: <d120d5000801110647k4b1fa49ene974898baf745aec@mail.gmail.com>
Date: Fri, 11 Jan 2008 09:47:11 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [BISECTED] Re: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
Cc: linux-input@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Pettersson" <william.pettersson@gmail.com>
In-Reply-To: <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0711141226n60323630rdc4833db0bfb2eeb@mail.gmail.com>
	 <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Jan 7, 2008 3:24 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> }, /* Dell Latitude D600 */
> +       { { 0x73, 0x02, 0x50 }, 0xcf, 0xff, ALPS_FW_BK_1 } /* Dell
> Vostro 1400 */
>  };
>
>
> After reverting, all buttons work as expected -- no lost syncs. I
> might add that my laptop is Acer Aspire 5720ZG. Also, the button in
> question is not truly a middle button; when operating correctly, it is
> used for scrolling (up/down). Now what can be done to make both models
> work correctly?
>

Thank you for identifying the problem commit. Could you please also do this:

echo 1 > /sys/module/i8042/parameters/debug
push and release left button
push and release rigth button
move finger on the touchpad a bit
echo 0 > /sys/module/i8042/parameters/debug
dmesg > dmesg.sync
echo 1 > /sys/module/i8042/parameters/debug
push and release middle button
echo 0 > /sys/module/i8042/parameters/debug
dmesg > dmesg.nosync

and send me both dmesg files?

Thank you.

-- 
Dmitry
