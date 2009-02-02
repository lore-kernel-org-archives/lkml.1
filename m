Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZBBWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZBBWrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZBBWrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:47:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbZBBWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:47:08 -0500
Date: Mon, 2 Feb 2009 14:41:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, andy@openmoko.com
Subject: Re: [PATCH 3/3] pcf50633_charger: Enable periodic charging restart
Message-Id: <20090202144131.41a8d279.akpm@linux-foundation.org>
In-Reply-To: <20090127135312.6875.94604.stgit@fedora.yogi>
References: <20090127135238.6875.26314.stgit@fedora.yogi>
	<20090127135312.6875.94604.stgit@fedora.yogi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 19:23:12 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> @@ -157,6 +213,7 @@ pcf50633_mbc_irq_handler(int irq, void *data)
>  		mbc->usb_online = 0;
>  		mbc->usb_active = 0;
>  		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
> +		cancel_delayed_work_sync(&mbc->charging_restart_work);
>  	}

eek, can't call cancel_delayed_work_sync() from an interrupt handler! 
If the work was actually running on this CPU or on a different one,
cancel_delayed_work_sync() will need to wait for it to complete.  The
kernel will explode in many tinkly little pieces.

