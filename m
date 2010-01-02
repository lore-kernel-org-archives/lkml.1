Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500Ab0ABTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0ABTRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311Ab0ABTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:17:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:38067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0ABTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:17:17 -0500
Date: Sat, 2 Jan 2010 11:19:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: users of mod_timer_msec()
Message-ID: <20100102111946.045611b6@infradead.org>
In-Reply-To: <877hs0724u.fsf@basil.nowhere.org>
References: <20100102104853.28505e39@infradead.org>
	<20100102105012.40d678f2@infradead.org>
	<877hs0724u.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Jan 2010 20:11:45 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> >  	emp->activity++;
> >  	if (!timer_pending(&emp->timer))
> > -		mod_timer(&emp->timer, jiffies +
> > msecs_to_jiffies(10));
> > +		mod_timer_msec(&emp->timer, 10);
> 
> ... but your original patch does
> 
> +int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms)
> +{
> +       return mod_timer(timer, msecs_to_jiffies(delay_ms));
> 

eh last minute typo

this is supposed to be jiffies + msecs_to_jiffies()

good catch; thanks!


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
