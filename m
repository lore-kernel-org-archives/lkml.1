Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZBGIBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZBGIBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 03:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZBGIAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 03:00:52 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:20826 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753299AbZBGIAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 03:00:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WCWBq9dKs5hnpMpCDQ/VXsW9ti2uLNNw7fkDRQMnbDbnvVYC1oiHUwEl3WYgsma6Kcb+ArOXdAkQ41LvPfakHud8vyJGfg3WICBNSav7ZUiy0Lk6Qk0VXlokEAUEBQyGDrYo/lyQwcsHtDvwU6i5pKtz/9XKLxY09t71Hdnh4q0=  ;
X-YMail-OSG: mNbtfcMVM1ld5QEbOfTtodiZ3PAMeQvhq7otQZasNr9Z1o1Jp_bmk7y3RNX4jhek2ZXVf7CgX1lh2yp0rBT2gwWvdB3XwbsyBEv9gDQlwvLGzUkfqlv_JOK.cGK3KseVRge0y5LwoOHmi2q6e6fOA1Nm
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Joonyoung Shim <dofmind@gmail.com>
Subject: Re: [PATCH] twl4030-gpio: Fix getting the value of the TWL4030 GPIO  output pin
Date: Sat, 7 Feb 2009 00:00:48 -0800
User-Agent: KMail/1.9.10
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <4e1455be0902062213o769a4d15ha0c892508839dbad@mail.gmail.com>
In-Reply-To: <4e1455be0902062213o769a4d15ha0c892508839dbad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902070000.49089.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, Joonyoung Shim wrote:
> If TWL4030 GPIO pin is output, must read the value from REG_GPIODATAOUTx
> register in twl4030_get_gpio_datainout().

Why "must"?  The goal is to return the *actual* value of the pin,
not the intended one.  When an external signal overwhelms the drive
capability of that GPIO -- just a couple mA -- the correct value
to return can't be the value written in the output register.

Plus, this patch won't even link ... you changed the name of the
function at its definition, but not at its use points.

NAK, unless you can show there's a real bug this addresses...

- Dave
