Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZK1Kas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZK1Kas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 05:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZK1Kar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 05:30:47 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59713 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZK1Kaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 05:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=iYL4gCW8EjG98liTlOH1lVn+bMuDjENuEM/W83OK34HV/iyd8jbafTTjBhhvwyQPSZ
         w9+DtCp57BXjy3g1qyIxYCh6lvBW1BmjEZwxSwVGK/552SevBqXR60MNMLqYmJXB5ifw
         S8Iq/cShcku0mXvEI2qVtoL5LRK3wzPByySyQ=
MIME-Version: 1.0
In-Reply-To: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
Date: Sat, 28 Nov 2009 11:30:51 +0100
Message-ID: <b170af450911280230g4a2f7f8ao64b46ce7e88ec929@mail.gmail.com>
Subject: Re: Backlight device class redesign
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 28 listopada 2009 01:30 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Currently we keep all registered controllers in /sys/class/backlgiht/
> without any grouping per display or per anything. We can not use
> grouping per GPU (as somewhere proposed) because one GPU can control
> (for example) two PANELS and TV - 3 displays needing backlight
> management. The most obvious and stable solution seems to be grouping
> per display.

Just in case I was not clear enough. We should make ACPI, platform and
GPU drivers register same panel backlight control under same name like
"panel-0". Backlight class device would create
/sys/class/backlight/panel-0 only. When touching files in this
backlight/panel-0/, blacklight class would call functions from the
most proper (ACPI > platform > GPU) driver.

I thought if we could use card number for anything. I recalled that
notebooks with hybrid gpu, where system should switch between weaker
and more powerful GPU watching load. In case of that notebooks PANEL
can be controlled by both: card0 and card1.

So finally I think we should just register panel0 by default
everywhere. And in future we could add some quirks in drivers (ACPI,
platform, GPU) that would register panel1, panel2... for such devices.

Any comments? Should I work on something like specified above?

-- 
Rafał
