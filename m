Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXKUPLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXKUPLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXKUPKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:10:53 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:46013 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXKUPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:10:52 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Felipe Balbi <me@felipebalbi.com>
Subject: Re: USB deadlock after resume
Date: Wed, 21 Nov 2007 16:10:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Markus Rechberger <mrechberger@gmail.com>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Laurent Pinchart <laurentp@cse-semaphore.com>
References: <d9def9db0711210642h23db950vdc0fe1b9802e3e8b@mail.gmail.com> <dd6afcb038a38716f46887681f05f367@felipebalbi.com>
In-Reply-To: <dd6afcb038a38716f46887681f05f367@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211610.58684.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 November 2007 schrieb Felipe Balbi:
> > Do you know any good way for performing a softreset within the driver?
> > The video application should get a continuous datastream after
> > resuming the notebook, so the driver shouldn't be unloaded.
> > The driver also keeps a list of previous camera settings which should
> > be set up again after resuming. Stopping the video application and
> > reattaching the device using ACPI (this board supports reconnecting
> > the device using ACPI) should be avoided.
> 
> When you suspend, you cut off vbus (afaik, correct me if I'm wrong), which
> means your device will get disconnected. One way to avoid this is enabling
> CONFIG_USB_PERSIST and trying with that on.

Suspend may or may not cut off power. If it does cut off power, resume() will
never be called, instead either disconnect() or reset_resume().

	Regards
		Oliver

