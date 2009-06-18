Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZFRAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZFRAgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZFRAf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:35:58 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:36023 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbZFRAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LPSiexwLADM5CC1OtKIkrc5PMktizM7Aabs86F9uVXSFCkgFRsG+x6wR09RXpkUtvU
         Qe+tAQUFMiIQwO9c5KZ7SlSorlq7qi2KdgRlzXV/xYKkLwBrQn9gFnIZPJARMAUM6XDN
         Ro6vx+kFeDcWvi3XpLaxqXOcaB+tiZ2ycTTF8=
MIME-Version: 1.0
In-Reply-To: <74962ea30906091729i3e445de8i7f45ccfe5e9ea234@mail.gmail.com>
References: <20090331230217.GA31599@srcf.ucam.org>
	 <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com>
	 <20090401170708.GA14167@srcf.ucam.org>
	 <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com>
	 <20090602140357.GA13548@srcf.ucam.org>
	 <74962ea30906090942r43d374e7ra00e5056eca040a8@mail.gmail.com>
	 <20090609164529.GA11592@srcf.ucam.org>
	 <74962ea30906091718o274a0968ica61ee7a8d915ed5@mail.gmail.com>
	 <20090610002236.GA19743@srcf.ucam.org>
	 <74962ea30906091729i3e445de8i7f45ccfe5e9ea234@mail.gmail.com>
Date: Wed, 17 Jun 2009 18:35:58 -0600
Message-ID: <74962ea30906171735j671b031dxfb6b4e41a44bf11b@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been playing w/ the omnibook module these days and I got hotkeys
"working".

I don't know why _Q43 is not being triggered, however I got the NTFY
method to activate the TECF variable and so I can finally poll the TOHK
variable to get the hotkey. I'm not sure is this is the correct way of doing
things but we are in business.

Basically this is what I did:

1. Activate HCI Hotkey Events call 0x1E
2. Pressing a hotkey generates an i8042 event (0x6e)
3. Evaluate NTFY method, so TECF is at one
4. Poll INFO method to get last pressed hotkey (once ;-) )
5. Generate keycode for that hotkey

Here's the output of the omnibook module while pressing Fn alone
and then Fn-Esc:

atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x100.
omnibook: generating keycode 464.
atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x17f.
omnibook: generating keycode 464.
atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x100.
omnibook: generating keycode 464.
atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x17f.
omnibook: generating keycode 464.
atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x101.
omnibook: generating keycode 113.
atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x101.
omnibook: generating keycode 113.
atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.
omnibook: detected scancode 0x100.
omnibook: generating keycode 464.


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
