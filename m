Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbYGOAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbYGOAXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbYGOAXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:23:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbYGOAX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:23:29 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 17:23:24 -0700
Message-Id: <1216081404.27455.97.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 16:53 -0700, Yinghai Lu wrote:
> so after this patchset, if i put qllogic fw in firmware/, that fw will
> work or not...

The qlogic driver already uses request_firmware(), like most modern
drivers do. If you want to include that firmware in your kernel image
(assuming it's in /lib/firmware already), do something like this:

	CONFIG_EXTRA_FIRMWARE="ql2500_fw.bin"
	CONFIG_EXTRA_FIRMWARE_DIR=/lib/firmware

Then it'll find that firmware file and pull it in to your kernel, and
you can set CONFIG_SCSI_QLA_FC=y and expect it to work. Select the right
firmware for your device, of course.

-- 
dwmw2

