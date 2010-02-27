Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967924Ab0B0H7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:59:34 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:56810 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967879Ab0B0H7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:59:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cps3Fu0no90SjlIgSzldif4lQS8cv507vWu2piv7fvphyxpo+cEPnKWdPF1reaXvbE
         vO23FLNrfwQABa0I13/q6cvxWr8bEhX94+3UuK9rjN2VhYt26GsdkVaCpzMy3ps0C1Dy
         YCWO1dYdjghiU6ZNrUQaENy1KO3j87U5KfZTQ=
Date: Fri, 26 Feb 2010 23:59:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 14/28] kgdboc,keyboard: Keyboard driver for kdb with kgdb
Message-ID: <20100227075927.GB793@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-15-git-send-email-jason.wessel@windriver.com>
 <20100226075755.GC17062@core.coreip.homeip.net>
 <4B87C8DF.4000805@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B87C8DF.4000805@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 07:13:03AM -0600, Jason Wessel wrote:
> Dmitry Torokhov wrote:
> > Hi Jason,
> > 
> > Sorry for not responding earlier.
> > 
> > On Thu, Feb 25, 2010 at 03:21:19PM -0600, Jason Wessel wrote:
> >> +++ b/drivers/char/kdb_keyboard.c
> > 
> > Does it have to live here? If you are going for completely separate
> > driver maybe it should be buried somewhere like xxx/kdb/kdb_keyboard.c
> > so nobody needs to look at it?
> 
> 
> I think in the long run we could consider integration with the primary
> keyboard driver via a polling hook.  I am happy to move the driver off
> into kernel/debug/kdb with the other kdb related files until that
> happens.
> 
> The original logic for putting next to the keyboard.c was because they
> are both fighting for the same HW.  Please let me know if this changes
> your mind, else I will go ahead and move the keyboard implementation
> into the kernel/debug/kdb.
> 

It does not behause in 2.6 the driver talking to the i8042 is called
i8042.c and it is located in drivers/input/serio.
drivers/char/keyboard.c does not talk directly to hardware anymore and
pc_keyb.c is long gone.

Given the fact that your code does not implement a character device I do
not see any reason for it to live in drivers/char.

Thanks.

-- 
Dmitry
