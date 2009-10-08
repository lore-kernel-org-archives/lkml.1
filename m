Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZJHFKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZJHFKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZJHFKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:10:18 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:42886 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZJHFKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n5JoYmDH5pBikaXCdMNooUmZQA8QJVE+QW8g0b7lan7tyrQEXXK0E6DnxXyVHlugMi
         dt7H5XtJ2rGzilpZWsqf2Fu6wUgDfO4h1EdDuMU7BBBC5gpAtOrfWnJWSgSfjvHtDejO
         sFupIzxUgbLP2R+I+2iPYJoCV0KuR2O+3OJps=
MIME-Version: 1.0
In-Reply-To: <20091006195413.GA1469@ucw.cz>
References: <20091006195413.GA1469@ucw.cz>
Date: Thu, 8 Oct 2009 10:39:39 +0530
Message-ID: <5d5443650910072209t63e3fa9dvff7ab2fee7bb2f88@mail.gmail.com>
Subject: Re: ads7846 touchscreen: fix pressure
From: Trilok Soni <soni.trilok@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: dtor@mail.ru, dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Oct 7, 2009 at 1:24 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> On Zaurus, pressure is reported inverted -- the lighter the pressure,
> the bigger numerical value. This should fix it.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> --- linux-rc/drivers/input.ofic/touchscreen/ads7846.c   2009-10-06 13:49:56.000000000 +0200
> +++ linux-rc/drivers/input/touchscreen/ads7846.c        2009-10-06 21:18:25.000000000 +0200
> @@ -608,12 +609,12 @@
>
>                input_report_abs(input, ABS_X, x);
>                input_report_abs(input, ABS_Y, y);
> -               input_report_abs(input, ABS_PRESSURE, Rt);
> +               input_report_abs(input, ABS_PRESSURE, ts->pressure_max-Rt);

but same behavior is seen by others using this chip on different
boards? If not, this has to be done through platform data.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
