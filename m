Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbZHJIes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbZHJIes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZHJIes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:34:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:6028 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZHJIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=YApwJiLfrqBfR06w1HQOtRT7ZaPdc/oFxqNo8I/6ZC+u6s8pmQ5KnvlmN943kYlnMd
         9cSBxV0QqVbYVq53A7fqBh07G6QVoSWgtVn39h3dmdKfKyLVw5ct4DIxJeRgB8nsagVX
         h0asquGqY4jciaYVhv9UjIIjbE7XcYT/Mj7zM=
Date: Mon, 10 Aug 2009 01:34:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matt Causey <matt.causey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serio / atkbd / PS/2 Strangeness with Serial port adapter
References: <ac71f2bb0908061315o1449e91dge1d5a63a2a4b986a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac71f2bb0908061315o1449e91dge1d5a63a2a4b986a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090810090508.69E02526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, Aug 06, 2009 at 09:15:01PM +0100, Matt Causey wrote:
> 
> So, I enabled debugging on the contoller driver(serio.c), and I see
> that the device generates noise when connected:
> 
> [  458.875614] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [444989]
> [  458.908119] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 0,
> 1, timeout) [445022]
> [  458.908144] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [445022]
> [  458.940151] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 0,
> 1, timeout) [445054]
> [  458.940225] drivers/input/serio/i8042.c: d4 -> i8042 (command) [445054]
> [  458.940234] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [445054]
> [  458.972190] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1,
> 12, timeout) [445086]
> [  458.972204] drivers/input/serio/i8042.c: d4 -> i8042 (command) [445086]
> [  458.972212] drivers/input/serio/i8042.c: ed -> i8042 (parameter) [445086]
> [  459.004227] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1,
> 12, timeout) [445118]
> [20171.684870] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0,
> 1) [20162195]
> 
> However - the atkbd driver does not pick the device up at all.
> 

Your device is steadely refusing to say that it is a keyboard - and so
atkbd driver does not bind to it.

> So, I did find a workaround (which is NOT acceptable for this
> deployment).  Remember the PS/2 'wedge' I mentioned?  Well, it has an
> extra PS/2 port for your keyboard.  If I connect a PS/2 keyboard to
> that thing, suddenly my scanner starts working.
> 
> We see some chatter from the controller driver, then one of these:
> 
> [23811.805578] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input6
> 

That happened because apparently the 'wedge' passes the inquirys to
the real keyboard and it answers propery.

I think the "i8042.dumbkbd" kernel parameter will solve your issue.

-- 
Dmitry
