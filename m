Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXBTPd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXBTPd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965078AbXBTPd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:33:59 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:6609 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059AbXBTPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:33:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kpbQuSQ//nisi5Eqy1+Le68VvNtshKHoPWOkMRT80V5/223I8E4Ym+uv9FVnGKYeBew760X35cNvgQcFc3QqBq+6Ycs/ZZpW6o7amR3GJxow/b0KG+cWuF3diVsD/lpdczW7Q1qXre7+h6mRoYhcsNFoZRPWlUaeXhZSMlsSpmA=
Message-ID: <68676e00702200733l6e7f13a5o201bc70fed98528b@mail.gmail.com>
Date: Tue, 20 Feb 2007 16:33:56 +0100
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Cc: "Jean Delvare" <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Chuck Ebbert" <cebbert@redhat.com>, lm-sensors@lm-sensors.org
In-Reply-To: <20070220151813.GA6581@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz>
	 <45D7461A.2040808@redhat.com>
	 <20070218183805.5a4fd813.khali@linux-fr.org>
	 <20070220151813.GA6581@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Feb 18, 2007 at 06:38:05PM +0100, Jean Delvare wrote:
>
> > ACPI is broken here, not k8temp, so let's fix ACPI instead. ACPI
> > doesn't conflict with only k8temp, but with virtually all hardware
> > monitoring drivers, all I2C/SMBus drivers, and probably other types of
> > drivers too. We just can't restrict or blacklist all these drivers
> > because ACPI misbehaves.
>
> No, the simple fact of the matter is that if you're running on an ACPI
> platform you need to change some of your assumptions. ACPI owns the
> hardware. The OS doesn't. To an extent this has always been true on
> laptops and servers /anyway/ - the BIOS is free to have a wide variety
> of SMM insanity that invalidates basic assumptions like "If I hold this
> lock, nothing can interrupt me between this write and this read". That's
> simply not true.
>
> So this isn't about fixing ACPI. It's about trying to find a mechanism
> that allows ACPI and raw hardware drivers to coexist, which is made
> somewhat harder by it not being a situation that the platform designers
> have considered in the slightest.

Motherboard vendors usually provide tools for $(TheOtherOS) that can
read from all thermal  / fan / voltage / whatever sensors, so I guess
it's possible to make the ACPI driver and the "raw" one play nice with
each other[1].

Luca
[1] Unless their solution is "poke at the hardware and hope that ACPI
doesn't blow up", that is.
