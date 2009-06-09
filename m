Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZFIQpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZFIQpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbZFIQpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:45:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55411 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350AbZFIQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:45:30 -0400
Date: Tue, 9 Jun 2009 17:45:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
Message-ID: <20090609164529.GA11592@srcf.ucam.org>
References: <20090331221107.GA30383@srcf.ucam.org> <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com> <20090331230217.GA31599@srcf.ucam.org> <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com> <20090401165345.GA13939@srcf.ucam.org> <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com> <20090401170708.GA14167@srcf.ucam.org> <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com> <20090602140357.GA13548@srcf.ucam.org> <74962ea30906090942r43d374e7ra00e5056eca040a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74962ea30906090942r43d374e7ra00e5056eca040a8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 10:42:00AM -0600, Azael Avalos wrote:

> However, everytime you poll the INFO method, the TECF variable receives
> a zero, so the next time you want to poll the INFO method, you
> receive a zero also, unless you "activate" the TECF variable again
> perhaps tru' _Q43 or by directly writing a one into it.

Right, but _Q43 should be called when you hit a hotkey. The fact that 
it's not is what's causing the problem here.

> 1. Activate Hotkey Events call 0x1E.
> 2. It activates something internally causing Hotkey Events being
>    stored in TOHK.
> 3. Whenever I press an Fn-Key combo let's say Fn-Esc, the actual key gets
>    stored in TOHK, in this case 0x101, but just lasting a couple seconds
>    (or even less...), it seems it's volatile.
> 4. Polling TOHK via the INFO method or directly gets me the actual hotkey,
>    but again, must real quick since it will disappear (I used 100 ms polling).
> 5. Figure out a way of getting those Hotkey Events in a nice manner...
>    I managed to get them, but sometimes I got them repeated due to the
>    polling timer...

When you hit a hotkey, what happens in /proc/interrupts? Do you see an 
i8042 event or an acpi event?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
