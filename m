Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031481Ab0B1HpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:45:21 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55540 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031462Ab0B1HpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xB6YzL1SMzAskfEXXSbdG/JyoK0fYbfIv5kSawLxKUIvpKwqPnEsKX/cfyoj3l+fDB
         B4o6HVMD6xJ4bExZEngYJzkbYqmOKoxQ2i9X343+cNKI98HO53ThFJX5eGzUhojEM2sb
         IVbDo3g2o9d7dUM1xP4YLfS120At19uwSgw30=
Date: Sat, 27 Feb 2010 23:45:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 14/28] kgdboc,keyboard: Keyboard driver for kdb with kgdb
Message-ID: <20100228074515.GD765@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-15-git-send-email-jason.wessel@windriver.com>
 <20100226075755.GC17062@core.coreip.homeip.net>
 <4B87C8DF.4000805@windriver.com>
 <20100227075927.GB793@core.coreip.homeip.net>
 <4B89E622.1070009@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B89E622.1070009@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 09:42:26PM -0600, Jason Wessel wrote:
> Dmitry Torokhov wrote:
> >
> >> The original logic for putting next to the keyboard.c was because they
> >> are both fighting for the same HW.  Please let me know if this changes
> >> your mind, else I will go ahead and move the keyboard implementation
> >> into the kernel/debug/kdb.
> >>
> >>     
> >
> > It does not behause in 2.6 the driver talking to the i8042 is called
> > i8042.c and it is located in drivers/input/serio.
> > drivers/char/keyboard.c does not talk directly to hardware anymore and
> > pc_keyb.c is long gone.
> >
> > Given the fact that your code does not implement a character device I do
> > not see any reason for it to live in drivers/char.
> >   
> 
> I buy your logic.   I have moved the kdb_keyboard.c to
> kernel/debug/kdb/kdb_keyboard.c.
> 
> Can I assume we have reached closure on this patch for the short term?
>

Yep.

> Eventually I would like to to get rid of kdb_keyboard.c entirely and
> replace it with some kind of way to atomically poll the input devices,
> but this is longer term.
> 

I am not sure how feasible it is. KDB would require hooking very deep
into driver internals do avoid deadlocking on already held locks...

-- 
Dmitry
