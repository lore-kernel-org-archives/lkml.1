Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYHNG7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYHNG7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHNG67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:58:59 -0400
Received: from usul.saidi.cx ([204.11.33.34]:50282 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682AbYHNG66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:58:58 -0400
Message-ID: <48A3D7A0.7010704@overt.org>
Date: Wed, 13 Aug 2008 23:58:40 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org> <20080807134530.GB17062@khazad-dum.debian.net> <48A06BBC.7060007@overt.org> <20080813092908.GA6806@khazad-dum.debian.net>
In-Reply-To: <20080813092908.GA6806@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> Looks like either rfkill-input is inactive, or something is binding to the
> toshiba_acpi input device and setting it to exclusive mode (X evdev does
> this).

Almost. Turns out there were two problems:

1) I was setting SW_RFKILL_ALL as a keybit instead of an swbit - so no
events reported. Whoops. :-)

2) Maybe this shouldn't surprise me, but the expected switch semantics
are that '1' means radios are on and 0 means they are killed - I thought
it was the other way round.

Now, when I release the kill switch, rfkill-input does indeed turn the
radio on. Great. The remaining problem is that rfkill-input is setting
it to soft-blocked when the switch is registered. I'm not sure why it's
deciding to do that. Anyway, I'm almost there. Thanks.

--phil

