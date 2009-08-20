Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZHTHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZHTHfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZHTHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:35:16 -0400
Received: from znsun1.ifh.de ([141.34.1.16]:59685 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbZHTHfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:35:15 -0400
X-Greylist: delayed 1928 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 03:35:15 EDT
Date: Thu, 20 Aug 2009 09:01:44 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
X-X-Sender: pboettch@pub3.ifh.de
To: Andy Walls <awalls@radix.net>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: linux-next: suspend tree build warnings
In-Reply-To: <1250729056.2716.37.camel@morgan.walls.org>
Message-ID: <alpine.LRH.1.10.0908200859060.7249@pub3.ifh.de>
References: <20090819172419.2cf53008.sfr@canb.auug.org.au>  <200908192338.03910.rjw@sisk.pl>  <20090819233601.GA2875@kroah.com> <1250729056.2716.37.camel@morgan.walls.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 19 Aug 2009, Andy Walls wrote:
>> Ick.  struct device should _never_ be on the stack, why would this code
>> want to do such a thing?

When you are doing a thing it does not necessarily you know that you're 
doing it.

> It appears that the state object is a dummy being used to detect and
> twiddle some identical chips on the i2c bus.  The functions called only
> use the "i2c_adapter" and "cfg" member of the dummy state object, but
> those functions want that state object as an input argument.
>
> <obvious>
> The simplest fix is dynamic allocation of the dummy state object with
> kmalloc() and then to free it before exiting the function.
> </obvious>

Even more obvious: Fix the function with simpler code to do the same 
thing.

I will try to fetch some time from somewhere to work on it.

--

Patrick 
http://www.kernellabs.com/
