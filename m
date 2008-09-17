Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYIQU4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYIQU4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYIQU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:56:13 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48991 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYIQU4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:56:13 -0400
Message-ID: <48D16EDB.8090700@lwfinger.net>
Date: Wed, 17 Sep 2008 15:55:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Michael Buesch <mb@bu3sch.de>, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> The LED state was not being updated by rfkill_force_state(), which will
> cause regressions in wireless drivers that had old-style rfkill support and
> are updated to use rfkill_force_state().
> 
> The LED state was not being updated when a change was detected through the
> rfkill->get_state() hook, either.
> 
> Move the LED trigger update calls into notify_rfkill_state_change(), where
> it should have been in the first place.  This takes care of both issues.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
>  John, this one is quite likely something that should be sent for
>  merge in mainline BEFORE 2.6.27 is released.
> 
>  I am NOT sure it fixes regressions, that depends on whether the drivers
>  using rfkill that are in 2.6.27 had working LED support before rfkill
>  support was added to them.  Unfortunately, it cannot fix the b43
>  regression by itself.

The b43 regression is not fixed with this patch and the one from
Matthew that starts out with "Oh, hey, I suck. This one might stand a
better chance of not falling over."

Larry


