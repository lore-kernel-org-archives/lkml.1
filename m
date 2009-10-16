Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZJPErx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZJPErx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZJPErw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:47:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:57318 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZJPErv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:47:51 -0400
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Timur Tabi <timur@freescale.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD770A9.6070509@freescale.com>
References: <1255557226-4403-1-git-send-email-timur@freescale.com>
	 <200910151305.47100.borntraeger@de.ibm.com>
	 <20091015160906.GA3730@loki.buserror.net>
	 <200910152041.26646.borntraeger@de.ibm.com>
	 <4AD770A9.6070509@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Oct 2009 15:46:45 +1100
Message-Id: <1255668405.19032.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 13:57 -0500, Scott Wood wrote:
> I'd say the dropping approach is quite undesirable (significant 
> potential for output loss unless the buffer is huge), unless there's 
> simply no way to safely spin.  Hopefully there are no such backends, but 
> if there are perhaps we can have them return some special code to 
> indicate that.

Should never spin. Best is to keep a copy in the upper layer of the
pending data and throttle (not accept further data from tty layer) until
we have managed to flush out that "pending" buffer.

> > If we just busy loop, it actually does not matter how we let hvc_console react 
> > on 0, as long as we adopt all backends to use that interface consistent.
> > 
> > On the other hand, backends might want to do special magic on congestion so I 
> > personally tend to let the backend loop instead of hvc_console. But I am really  
> > not sure.
> 
> Doing it in the backend requires the backend to know whether it's being 
> called for printk or for user I/O.  In the latter case, we don't want to 
> spin, but rather wait for an IRQ (or poll with a timer if there's no IRQ). 

Ben.


