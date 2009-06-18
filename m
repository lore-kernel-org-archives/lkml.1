Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbZFRNeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbZFRNeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZFRNd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:33:56 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55476 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZFRNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AJtwHua4Is2Dy+TMa5ZdP4/sluWGzHKCdsPtj82j9joRH8hNd1F8v7y2d0MPboCutk
         oz+24FoV4eWcleTjATMLufXqRT072EU6Uq8k5GPuUXo3nwfxrS0ZodxIvJSPM465HB94
         aEbQvmbnGGiFKw9FiizHFP4qvnwP9v/SJpo0A=
MIME-Version: 1.0
In-Reply-To: <15e53e180906160304u37f8c702m808ece710359ef9a@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
	 <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
	 <71cd59b00906141226k37b90b9ey7347ed85ec17a17b@mail.gmail.com>
	 <61b223ba0906150109r3a69e98aq949c7f2df5563c6e@mail.gmail.com>
	 <15e53e180906160133j7055536cqe5b9515704fd4d94@mail.gmail.com>
	 <4A375914.5050800@tuffmail.co.uk>
	 <15e53e180906160147w1fa6282dl50e8e728f067e090@mail.gmail.com>
	 <71cd59b00906160244t21bc0553tc8e209c70497687d@mail.gmail.com>
	 <15e53e180906160304u37f8c702m808ece710359ef9a@mail.gmail.com>
Date: Thu, 18 Jun 2009 14:33:57 +0100
Message-ID: <9b2b86520906180633i2bc2ad6bk20c43d8426798b18@mail.gmail.com>
Subject: Re: [gpm] [PATCH 2.6.29] eeepc-laptop: report brightness control 
	events via the input layer
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Richard Hughes <hughsient@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
       gnome-power-manager-list@gnome.org,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/09, Richard Hughes <hughsient@gmail.com> wrote:
> On Tue, Jun 16, 2009 at 10:44 AM, Corentin
> Chary<corentin.chary@gmail.com> wrote:
>> Ok, so we just need to patch this file :
>> http://cgit.freedesktop.org/hal-info/tree/fdi/information/10freedesktop/10-laptop-panel-hardware.fdi
>
> Yes
>
>> But I'm not sure how to do it to make it works on all Eeepc.
>
> Well, really we want to match "classes of eeepc", so matching with
> prefix might be a good idea.
>
> Richard.

Yes please!  I see the 701 is (just added?) on the list, but this
applies to any hardware which is driven by the eeepc-laptop driver.
There is no "brightness up key" or "brightness down key" notification
recognised by the driver, only "brightness level is now equal to X".

Btw, I looked at other drivers and fujistsu-laptop is implemented in
the same way.

I guess the problem is the DMI manufacturer and product name don't
mention "EeePC".  At least on my model, the serial number starts with
"EeePC-", so we _could_ try to use that.

But I hope there's a nicer solution.  Corentin, do you think it would
be correct to apply this quirk to _all_ Asus laptops?

At the moment asus-laptop doesn't generate brightness events.  The
deprecated asus-acpi driver generates brightness events (via the old
procfs interface).   But the BR_UP/BR_DOWN events carry an absolute
brightness value; it strongly suggests that the firmware modifies the
brightness.  asus-acpi uses the brightness value to update a generic
backlight device - so we already rely on the value being correct,
otherwise g-p-m's heuristic won't work.

Thanks
Alan
