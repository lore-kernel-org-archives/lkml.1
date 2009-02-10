Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZBJV3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZBJV3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZBJV3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:29:01 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54430 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZBJV3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u2mCtLKf0q3jzVp4ZLmcjE1hyvDkNA4YRjxguKdd11VhPn1dY+YyjuGJshih1Z+MJf
         iLCht8URY9jbSuHj2vP4Zyz+zydWy5J0+xqE/PQRmvqoot/CHEQgduz/Kc7qo6JpssSG
         bacO8PVy5UBPcpabft1e46kt2xcuhN+RrU9aE=
MIME-Version: 1.0
In-Reply-To: <49917650.1060208@tudelft.nl>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>
	 <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>
	 <49915832.1090501@tremplin-utc.net>
	 <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
	 <49917650.1060208@tudelft.nl>
Date: Tue, 10 Feb 2009 22:28:58 +0100
Message-ID: <cb7bb73a0902101328n25f64c9dqd6dabe62b05273ac@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
Cc: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       Palatis Tseng <palatis@gmail.com>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:42 PM, Éric Piel <E.A.B.Piel@tudelft.nl> wrote:
> Can you try something like this in lis3lv02d_poweron():
>        adev.read(handle, CTRL_REG2, &val);
>        val |= CTRL2_BDU | CTRL2_IEN;
> +       val &= ~CTRL2_BLE;
>        adev.write(handle, CTRL_REG2, val);

Ok, this is getting crazier and crazier. Apparently, setting the
CTRL2_BLE bit this way makes no difference, and so does setting it
with val |= (i.e. enabling it): in both cases, if I debug
lis3lv02d_read_16 I always get 0 in the lower byte and something in
the upper byte.

By forcefully swapping lo and hi I actually get very little
fluctuations in the Y and Z axes (so small that jstest doesn't detect
them), but I still get huge (4k) fluctuations in the X axis:
apparently, this axis has very small SIGNED fluctuations around the 0,
which translate to fluctuations between 255 and 1

Now, the lo/hi thing might be solved some other way (e.g. by checking
the BLE bit and relying on its setting instead of trying to force it,
and then swapping hi and lo as needed). But how do we solve the
SIGNEDNESS of lo ?


-- 
Giuseppe "Oblomov" Bilotta
