Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXFKVGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXFKVGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXFKVGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:06:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:7562 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbXFKVGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PjC123cz29Vrq7ddA+Hb0j77i5hnSOIpEGI7l3ReR0XR3J4CKVHIPgVHex/71WBPDC50RmspsTtUbmysGcvXlA0qY00w/bgo8M9t08qN1zRoA/BuFM+8Z1rNNLKF/okJ3ARQtzFJGAWBjFX5j7+BBN71AuiD1bUUJc7geI55jW8=
Message-ID: <68676e00706111406r16eafd0eseaf1fb24f5c0d075@mail.gmail.com>
Date: Mon, 11 Jun 2007 23:06:21 +0200
From: Luca <kronos.it@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <466CFD6D.2080201@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070603213432.GA3075@dreamland.darkstar.lan>
	 <4663DCE9.3000107@qumranet.com>
	 <20070604202248.GA18668@dreamland.darkstar.lan>
	 <46647B3E.2090205@qumranet.com>
	 <20070604212207.GA22365@dreamland.darkstar.lan>
	 <46651069.5040003@qumranet.com>
	 <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com>
	 <466BED18.5040708@qumranet.com>
	 <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>
	 <466CFD6D.2080201@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Avi Kivity <avi@qumranet.com> wrote:
> Luca wrote:
> >>
> >> I've managed to reproduce this on kvm-21 (it takes many boots for this
> >> to happen, but it does eventually).
> >
> > Hum, any clue on the cause?
>
>  From what I've seen, it's the new Linux clocksource code.

Actually I tried forcing the PIT (and any other combination of
tsc,acpi_pm,jiffies) as the clocksource, without success.

> > Should I test older versions?
>
> They're unlikely to be better.  Instead, it would be best to see what
> the guest is doing.
>
> I suggest downloading the source rpm for the kernel, building it, and
> sprinkling printk()s until we know exactly what source the guest is
> executing at the time of the hang.

Ok, will do. Meanwhile I discovered that the kernel on the boot cd
(the one that hangs) is compiled for i586, while the one installed on
disk is for i686 (this one works).

i686 has this options enabled:

+CONFIG_X86_GOOD_APIC=y
+CONFIG_X86_USE_PPRO_CHECKSUM=y
+CONFIG_X86_TSC=y

but disabling tsc on the command line doesn't make any difference. Is
it possible that KVM is choking on some instruction not used by the
i686 kernel?

Luca
