Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZJPSDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZJPSDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZJPSDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:03:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:54531 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZJPSDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:03:49 -0400
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Timur Tabi <timur@freescale.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091016153330.GB11838@loki.buserror.net>
References: <1255557226-4403-1-git-send-email-timur@freescale.com>
	 <200910151305.47100.borntraeger@de.ibm.com>
	 <20091015160906.GA3730@loki.buserror.net>
	 <200910152041.26646.borntraeger@de.ibm.com>
	 <4AD770A9.6070509@freescale.com> <1255668405.19032.13.camel@pasglop>
	 <20091016153330.GB11838@loki.buserror.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Oct 2009 05:03:24 +1100
Message-Id: <1255716204.19032.27.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 10:33 -0500, Scott Wood wrote:
> On Fri, Oct 16, 2009 at 03:46:45PM +1100, Benjamin Herrenschmidt wrote:
> > On Thu, 2009-10-15 at 13:57 -0500, Scott Wood wrote:
> > > I'd say the dropping approach is quite undesirable (significant 
> > > potential for output loss unless the buffer is huge), unless there's 
> > > simply no way to safely spin.  Hopefully there are no such backends, but 
> > > if there are perhaps we can have them return some special code to 
> > > indicate that.
> > 
> > Should never spin.
> 
> Why is a hypervisor console different than a serial port in this regard?

Ah sorry, yeah, struct console can I suppose, it's the tty that
shouldn't.

> > Best is to keep a copy in the upper layer of the pending data and throttle
> > (not accept further data from tty layer) until we have managed to flush
> > out that "pending" buffer.
> 
> The data isn't coming from the tty layer -- we're talking about printk.  How
> do you throttle that without spinning?
> 
> I agree that it shouldn't spin when handling tty I/O.

Ben.


