Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbXKQIyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbXKQIyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 03:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbXKQIxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 03:53:53 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:3350 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXKQIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Cih9pC5VqEtYAxAbWfkmcO3WtYNROADu3h3x7h+t9zMV/+EXpgsudErjd0OWw3PvvnND6EGF0T+fJ82LdLAmVuW802HDzcr3UWj+DRLuCnyR8TfEEwZAAf+AENV7fkhLDYzx7JItv97PbCyurntMT04cnPegwI6/wr9ebL8bUio=
Message-ID: <473EAC1A.1000205@gmail.com>
Date: Sat, 17 Nov 2007 09:53:46 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: apm emulation driver broken ?
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711161720.50313.rjw@sisk.pl> <cda58cb80711160929i4dbac6b7xb9d1bcc9223ddd7b@mail.gmail.com> <200711162220.56494.rjw@sisk.pl>
In-Reply-To: <200711162220.56494.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> However, using PF_NOFREEZE to prevent this from happening doesn't seem to be
> a good idea.
> 

Indeed but...

> I'd probably use wait_event_freezable() (defined in
> include/linux/freezer.h) for that.

...I would just revert this bits from now to make sure this driver
work again for v2.6.24.
 
> It tries to send them fake signals and waits for them to freeze.  If
> they don't freeze within the timeout, it fails and clears their
> TIF_FREEZE bits.

But send_fake_signal() seems to wake up task in INTERRUPTIBLE state
only. Looking at signal_wake_up(), it basically do:

	wake_up_state(t, TASK_INTERRUPTIBLE);

What am I missing ?

		Franck

