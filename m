Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbZKYMoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbZKYMoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934241AbZKYMoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:44:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:38488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934121AbZKYMod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:44:33 -0500
Date: Wed, 25 Nov 2009 04:35:34 -0800
From: Greg KH <gregkh@suse.de>
To: eran liberty <eran.liberty@gmail.com>
Cc: balajirrao@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: kobjects: mark cleaned up kobjects as unitialized
Message-ID: <20091125123534.GA17486@suse.de>
References: <ffc2b1d40911250127x7b3c3609qb99820d212a7a0ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffc2b1d40911250127x7b3c3609qb99820d212a7a0ad@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 11:27:58AM +0200, eran liberty wrote:
> Hi Greg & Balaji,
> 
> After diving into the LDKM and failed to spot the point where you
> actually un-initialize the 'state_initialized' of a kobject... and
> since I have statically allocated object which trip over this very
> same trap...

Ah, there's your problem, don't statically allocate a kobject.  Fix that
and your issue goes away, right?

> Google-ing for others who fell into this trap, I found your thread/patch at:
> http://lkml.org/lkml/2008/3/8/155
> and
> http://lkml.indiana.edu/hypermail/linux/kernel/0902.0/01969.html
> 
> I noticed this patch did not make it into the mainline.
> 
> Is this patch still valid?
> Is there some other, better way to do it by the book?

Do not statically allocate a kobject.

> Right now I by-pass the problem by memset-ing the whole object after I
> release it... but I feel this is a bit brutal.

You should be freeing your memory in your release function.

Do you have a pointer to your code somewhere?

thanks,

greg k-h
