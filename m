Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbXKHKOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbXKHKOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXKHKOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:14:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57814 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753450AbXKHKOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:14:05 -0500
Date: Thu, 8 Nov 2007 12:14:13 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Philippe Elie <phil.el@wanadoo.fr>
Cc: oprofile-list@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] AVR32: Oprofile support
Message-ID: <20071108121413.4919e4a3@siona>
In-Reply-To: <20071108092806.GB2889@zaniah>
References: <1194444333-9264-1-git-send-email-hskinnemoen@atmel.com>
	<20071108092806.GB2889@zaniah>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 10:28:06 +0100
Philippe Elie <phil.el@wanadoo.fr> wrote:

> On Wed, 07 Nov 2007 at 15:05 +0000, Haavard Skinnemoen wrote:
> > +	/* PCCNT */
> > +	if (ctr->enabled && (pccr & ctr->flag_mask)) {
> > +		sysreg_write(PCCNT, -ctr->count);
> > +		oprofile_add_sample(regs, PCCNT);
> > +	}
> > +	ctr++;
> > +	/* PCNT0 */
> > +	if (ctr->enabled && (pccr & ctr->flag_mask)) {
> > +		sysreg_write(PCNT0, -ctr->count);
> > +		oprofile_add_sample(regs, PCNT0);
> > +	}
> > +	ctr++;
> > +	/* PCNT1 */
> > +	if (ctr->enabled && (pccr & ctr->flag_mask)) {
> > +		sysreg_write(PCNT1, -ctr->count);
> > +		oprofile_add_sample(regs, PCNT1);
> > +	}
> 
> Why not a loop here ?

The system register is coded into the instruction as an immediate, so
it would have to be a loop with a switch in it. And with only three
counters, I thought it looked cleaner (and faster) this way.

Håvard
