Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXHGJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXHGJcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbXHGJcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:32:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:42086 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXHGJcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=P2+78CQxiiypd2m6ZUowIB1YSyTz+d4ZVe7akE1s9ll/n5pQLq5QRfYTiNd32lVfRBIXg2bLj4ax8JkqSkKk+QXOk+QHlBQ8ogFLzH1pkms551pZz6h59YrL1KiLDKUjS8SoDgP948Q1cyBL/k3qwiRVwZsif4g6sippxsKa244=
Message-ID: <46B83C0B.8050902@gmail.com>
Date: Tue, 07 Aug 2007 18:31:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michael Sedkowski <sedmich@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>	 <1186411815.4355.7.camel@nx6310>	 <20070806150159.GC31615@khazad-dum.debian.net>	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>	 <1186424492.4355.1.camel@nx6310>  <46B76BBC.9010107@gmail.com>	 <1186438698.4402.6.camel@nx6310>  <46B817AB.30105@gmail.com> <1186478319.3705.3.camel@nx6310>
In-Reply-To: <1186478319.3705.3.camel@nx6310>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Sedkowski wrote:
> Dnia 07-08-2007, Wt o godzinie 15:56 +0900, Tejun Heo napisał(a):
>> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
>> Always       -       388
>>
>> I think this is the one.  You can test it by forcefully powering off
>> the
>> machine (press power button for several secs or disconnect AC and
>> battery) and see whether the count increases.
>>
> When I forcefully power off using the power button the raw value [last
> one] rise by 1 point from 389 to 390. When I power off normally with
> linux it remains constant.
> Now could some one please explain to me what does that mean and am I in
> danger of data loss?

So, the ACPI routine puts the disk into the standby mode before powering
off.  That's good.

On power off, the r/w heads in a disk should be unloaded (parked).  This
is usually achieved by either putting the disk into standby/sleep mode
during shutdown.  However, all modern disks can automatically unload
their heads when the power is removed abruptly.  This is called
emergency unload.  Emergency unload does shorten the lifespan of the
disk but you don't have to worry too much about it.  Disks are designed
to withstand certain number of emergency unloads.

-- 
tejun
