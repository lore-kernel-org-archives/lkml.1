Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab0BYEMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:12:19 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46675 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0BYEMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:12:16 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
Date: Thu, 25 Feb 2010 05:11:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Bruno =?iso-8859-1?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       "Jiri Kosina" <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Nicu Pavel" <npavel@ituner.com>
References: <20100221002001.0a7e05a7@neptune.home> <201002241927.53532.oliver@neukum.org> <ffb352764fc5a0da5cca6f3da7fc2603.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <ffb352764fc5a0da5cca6f3da7fc2603.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002250511.52284.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Februar 2010 22:44:53 schrieb Rick L. Vinyard, Jr.:
> The issue, as I understand it is that non-interrupt code may obtain the
> lock and then the interrupt code is executed... hence the deadlock and the
> need to use spin_lock_irqsave() and spin_unlock_irqrestore().

Yes.

> If that is correct, is there any problem with the following approach?

Why not always a workqueue or alternatively spin_lock_irq() when
you are not in interrupt? This approach seems needlessly complicated.

Secondly, when you hold a spinlock, you must use GFP_ATOMIC.
GFP_NOIO is insufficient.

	Regards
		Oliver
