Return-Path: <linux-kernel-owner+w=401wt.eu-S964863AbXH3Tj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbXH3Tj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbXH3TjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:39:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:17066 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbXH3TjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Zg/M28kIaDU6+MuU5S2RetS84V7E68fTpK3B6nwIVIHhy3y5aBwlUnTM0CngQUO/WrJERBzylPuVxBV6Pkp+2v8vJHwTSpIbO1n1WP7jArapJ8Khgv6J62KQCD9/vnCha/CYegqPSvPpxI+mpznV+cI88tLHxyBpmahAXh/6Un8=
Message-ID: <3ae72650708301239i6cda2c23r6a970f447ddaa82d@mail.gmail.com>
Date: Thu, 30 Aug 2007 21:39:17 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data Protection System 3D ACPI driver (resend)
Cc: "Yan Burman" <burman.yan@gmail.com>,
       "Shem Multinymous" <multinymous@gmail.com>,
       hdaps-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <20070830164132.GA21023@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz>
	 <46D01420.3070400@gmail.com>
	 <20070827171107.GA15647@khazad-dum.debian.net>
	 <46D5A742.8090201@gmail.com>
	 <20070829233024.GA7433@khazad-dum.debian.net>
	 <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com>
	 <46D6E5CD.4060807@gmail.com>
	 <20070830164132.GA21023@khazad-dum.debian.net>
X-Google-Sender-Auth: 68e3b7764fed300f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Thu, 30 Aug 2007, Yan Burman wrote:
> >>> You can generate events on input devices, but I am not sure that's the
> >>> best way to go about it for this.  Things that block on read until an
> >>> interrupt happens might work better.
> >>
> >> You can do the latter via another (4th) input device.
> >>
> > What's wrong with the stuff I did in mdps? a misc character device that
> > acts like /dev/rtc. Why does it have to be input device oriented?
>
> I am fine with a char device that acts like /dev/rtc, but if we are doing
> something as heavyweight as a char device, I'd rather we go full generic
> netlink and send the various events over it.  We'd have a netlink device
> that sends everything over various "channels" and just one input device that
> does joystick emulation, then.
>
> Can we use a simple sysfs attribute that blocks the caller on write and
> returns immediately on read?

Sysfs files support poll, if they are implemented that way. A driver
can wake up listeners that wait in poll() for changes.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4508a7a734b111b8b7e39986237d84acb1168dd0

Kay
