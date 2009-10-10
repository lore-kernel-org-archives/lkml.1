Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZJJIEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZJJIEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 04:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZJJIEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 04:04:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:37890 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbZJJIER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 04:04:17 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>
In-Reply-To: <4AD03A03.5050702@draisberghof.de>
References: <1255134315.2139.8.camel@pasglop>
	 <4AD03A03.5050702@draisberghof.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 18:41:01 +1100
Message-Id: <1255160461.3387.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 09:38 +0200, Josua Dietze wrote:
> Benjamin Herrenschmidt schrieb:
> 
> 
> > The symptom is that the USB modem just disconnects/reconnects in a loop.
> > The log looks like what I pasted below when plugging the device (and
> > leaving it in, the disconnects don't correspond to the device being
> > removed).
> 
> 
> This is one of the mode switching devices. It is switched to modem 
> mode by "usb_stor_huawei_e220_init".
> 
> Something keeps resetting it to initial mode. It might be a 
> powersave/suspend issue.

suspend is a good candidate yeah, autosuspend might be causing something
like that, I'll see what I can find. I didn't spot an obvious change to
the USB suspend policy between those two kernels, but it could be
trigged by one of the numerous changes that went into usb-serial.

Cheers,
Ben.

