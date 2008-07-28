Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbYG1Mgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbYG1Mgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbYG1Mgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:36:31 -0400
Received: from smtp.knology.net ([24.214.63.101]:54482 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYG1Mg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:36:29 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1217215009.2970.7.camel@jaswinder.satnam>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
	 <1217215009.2970.7.camel@jaswinder.satnam>
Content-Type: text/plain; charset=utf-8
Date: Mon, 28 Jul 2008 08:36:25 -0400
Message-Id: <1217248585.22789.58.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 08:46 +0530, Jaswinder Singh wrote:
> On Sun, 2008-07-27 at 21:43 -0400, David Dillow wrote:
> > It is not quite this simple. By not loading the firmware on device
> > probe, you have opened the door to a broken resume, and the driver will
> > now try to sleep in an atomic context, when typhoon_tx_timeout() is
> > called at the very least.
> > 
> 
> I just added the request_firmware support and
> replaced ﻿typhoon_firmware_image with ﻿fw->data.
> I do not think this will make any difference in rest of driver.

Please re-read what I said -- you broke error handling and potentially
resume. Previously, the firmware was available without a sleeping call
to user space to get it. Now, it is not. You cannot sleep in
typhoon_tx_timeout(), and trying to get a firmware image in resume is
going to be a problem if your file system is NFS mounted over the NIC
you're trying to resume.

http://marc.info/?l=linux-kernel&m=121608383506190&w=2
http://marc.info/?l=linux-kernel&m=121608255704704&w=2


