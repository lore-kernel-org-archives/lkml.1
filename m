Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbYDNTH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbYDNTH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYDNTHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:07:15 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:48430 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbYDNTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:07:13 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Date: Mon, 14 Apr 2008 20:06:50 +0100
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080414012038.GB14406@khazad-dum.debian.net> <200804141400.41319.IvDoorn@gmail.com>
In-Reply-To: <200804141400.41319.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804142006.51224.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 14 Apr 2008 19:06:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 13:00:41 Ivo van Doorn wrote:
> > > See rt2x00 and b43 in driver-wireless for an example implementation
> > > of pollable input device and rfkill
> >
> > They're broken by design, at least in b43's case.  Someone (Carlos, I
> > believe?) posted an example of a ping-pong scenario using b43.
>
> Thats true. But was that a scenario where there were 2 keys for the same
> radio type? Or was that a matter of the driver indicating a key pressed
> event while it has no attached key to it, and only checked the register for
> the key status and the current radio status and saw it was different?

Two part problem:

1) Bug in rfkill; rfkill is toggling all devices in the same state, and not 
actually checking the type.

(I submitted a patch for this on Sunday, although I sent it to linux-wireless 
before you sent the MAINTAINERS patch with netdev as the official list; but I 
did CC you on it regardless so you should have seen this. If not, let me know 
and I'll resend it).

2) The cycle-of-doom bug, as described earlier.

This still applies.

Yes, b43 can also be fixed not to emit a keycode if it cannot control the 
rfkill switch; but that doesn't solve the case of what happens if both the 
wireless driver and the platform driver can control the radio.

I agree wholeheartedly with Henrique here though - wireless drivers should 
_not_ be using key press events as a reporting mechanism.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
