Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbYHGM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbYHGM0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYHGMYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:24:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189AbYHGMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:24:44 -0400
Date: Thu, 7 Aug 2008 11:12:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Message-ID: <20080807111216.6cfdbeea@lxorguk.ukuu.org.uk>
In-Reply-To: <m18wv9iqn9.fsf@frodo.ebiederm.org>
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	<m1hc9yjb7x.fsf@frodo.ebiederm.org>
	<86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	<m1y739j2z8.fsf@frodo.ebiederm.org>
	<20080807002638.04699eac@lxorguk.ukuu.org.uk>
	<m18wv9iqn9.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 18:02:18 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > A lot of these are range checks so could be replaced by a single
> > valid_irq(irq) test.
> 
> Yes.  My first impression was that with NR_IRQS dead valid_irq could
> easily become. #define valid_irq(irq) ((irq) != 0) 

Not really - there are lots of cases where we sanity check an IRQ passed
from user space or module parameter configuration. So we do actually need

	valid_irq(irq)		((irq) > 0 && (irq) < nr_irqs)

[or relevant per arch alternatives]

Alan
