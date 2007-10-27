Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXJ0UZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXJ0UZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXJ0UY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:24:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:11459 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbXJ0UY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=O4cwraLBXYj3pcW+OOEo0fZnVBdo5nUJRNXvQHbSSk97bh0nvdlmZWx19/w4SqeytubixyY42xofaeiT8PBiZ8bsXTGk04DTvELRqUMKKiILZT/SW4DuEWohsxQqnRYlLYmojSx1npW34A8bCVtcx7NOYVhI1mtsn3eKPyTh7to=
Date: Sun, 28 Oct 2007 00:24:49 +0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-ID: <20071027202449.GF9816@martell.zuzino.mipt.ru>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0710251734190.17781@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710251734190.17781@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 05:40:03PM +0200, Jan Engelhardt wrote:
> On Oct 21 2007, Alexey Dobriyan wrote:
> >
> >One of type of bugs steadily being fought is the following one:
> >
> >	unsigned int flags;
> >	spin_lock_irqsave(&lock, flags);
> >
> >where "flags" should be "unsigned long". Here is far from complete list 
> >of commits fixing such bugs:
> >
> 
> How about making spin_lock_irqsave actually take a pointer to flags? 

How would you do it without flag day?

> (Which would be the logical choice if it were a function and not a 
> macro...) That would flag up all violations ("without cast to different 
> pointer" or so) while usually not breaking compilation.
> 
> Of course, irq_flags_t is probably the best long-term solution if one 
> wants to hide a struct. (Even then perhaps, use a pointer instead?)

IIRC, Christoph mentioned:

	irq_flags_t flags;

	flags = spin_lock_irqXXX(&lock);
	spin_unlock_irqYYY(&lock, flags);

where XXX and YYY are still to be found good names :^) It's also a solution
without flag day and with more sane lock part -- "how flags are modified
if they are passed by value?"

I start to like this proposal but I can't come up with good names.
