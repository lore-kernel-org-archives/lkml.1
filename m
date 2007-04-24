Return-Path: <linux-kernel-owner+w=401wt.eu-S1422909AbXDXRxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422909AbXDXRxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422941AbXDXRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:53:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:42421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936AbXDXRxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:53:00 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver
Date: Tue, 24 Apr 2007 19:53:04 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20070424174953.GB6798@traven>
In-Reply-To: <20070424174953.GB6798@traven>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704241953.04336.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 24. April 2007 19:49 schrieb Matthias Kaehlcke:
> @@ -1706,7 +1706,7 @@ static int rp_write(struct tty_struct *tty,
>         if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
>                 return 0;
>  
> -       down_interruptible(&info->write_sem);
> +       mutex_lock_interruptible(&info->write_mtx);

This is a bug. It is also present in the current code, but nevertheless
it is a bug. If you use an interruptible lock, you must be ready to deal
with interrupts, which are ignored by this code.

	Regards
		Oliver
