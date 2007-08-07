Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXHGGyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXHGGyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXHGGyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:54:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:10260 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbXHGGx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=q2pdo28dw6/7mhY4oedtgCqj+Br4uoBwaTLG6/65Z87CzHHZsGhK3Ppa9tOcYiPCZZk0cQdXox8zkwHrRSJW35BJY9lY5lePZfApDKwyi49Ysjs6Sld1Q8MpBU/16c79G4PXuygYMCK5D0bl1EXTR70tIu1k13zz5UykxlLYaMc=
Message-ID: <46B816FF.7060303@gmail.com>
Date: Tue, 07 Aug 2007 15:53:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <1186411815.4355.7.camel@nx6310> <20070806150159.GC31615@khazad-dum.debian.net> <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com> <20070806234509.GC27640@khazad-dum.debian.net>
In-Reply-To: <20070806234509.GC27640@khazad-dum.debian.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Tue, 07 Aug 2007, Tejun Heo wrote:
>> Michael Sedkowski wrote:
>>>> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
>>>> pulling unnecessary stunt.  Please apply the attached patch and report
>>>> when the disk spins down and up.
>>> Disk spins down on "Pre-shutdown prepare" and then goes up and down on
>>> "Power down".
>> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
>> it spins down the disk correctly.  Does emergency unload count increase
>> after each power down?  Also, please post the result of 'dmidecode'.
> 
> You know, this actually make a lot of sense, and one can't even complain
> about firmware that pulls that off.

Well, I'm complaining.  I think the problem here is that it isn't clear
which one is who's responsibility.  There's a Korean saying which
approximately translates into "if you have too many boatmen on a ship,
it goes to mountain".  We also have a bunch of Toshiba laptops which
want the ATA controller to be in enabled state when ACPI suspend is
invoked because the suspend method apparently wants to execute some
commands before going to sleep.

I wish ACPI spec carries a big fat sign saying "stay f*** away from
anything which isn't essential to the requested operation".

> Any chances of changing things
> so that we inspect/snoop all tasks sent to the device, and filter them
> out, or react to them accordingly?

No, we can't unless we snoop ACPI method execution and detect accesses
to IO ports or iomem regions.  It's not going through any driver.  This
is a gross mess.

-- 
tejun
