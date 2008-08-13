Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYHMJ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYHMJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYHMJ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:29:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44416 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYHMJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:29:14 -0400
X-Sasl-enc: 7Btda9jHmO+Ni/n9k6p2js9L/MSmouhcvtqVkVcgpCoP 1218619752
Date: Wed, 13 Aug 2008 06:29:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v2)
Message-ID: <20080813092908.GA6806@khazad-dum.debian.net>
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org> <20080807134530.GB17062@khazad-dum.debian.net> <48A06BBC.7060007@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A06BBC.7060007@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008, Philip Langdale wrote:
> Henrique de Moraes Holschuh wrote:
>> Hmm?  UNBLOCKED means it is not being rfkilled.  Why is not working?  Put
>> some debug printks on your toggle_radio callback, that might help fix the
>> issue...
>
> Well, what I see is this:
>
> At modprobe, I get an explicit unblock request. When I modify 'state' in sysfs,
> I see appropriate requests to soft block and unblock. When I activate the hardware
> kill switch, the rfkill state goes to hard_block but no one calls toggle_radio
> and when I release the kill switch, the state goes to soft_block and no one
> calls toggle_radio.

Looks like either rfkill-input is inactive, or something is binding to the
toshiba_acpi input device and setting it to exclusive mode (X evdev does
this).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
