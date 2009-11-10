Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZKJJzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZKJJzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZKJJzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:55:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43470 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZKJJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T4othvIwpaCQ2h7qK4eaUWQoYyVst8dc3hbmAX27seLtY3UTTW7gDfJcTjluuyIjGP
         pvrl1KdJZjZRZ/K/s6d9NLFphn9D3NbX1skEyHTq8GKYpevS56aiHMiWxIiwMcX0/5tP
         0UgeYFWcXRpSgt1wS6cPGPgdEGxTHBCjMPGB4=
Subject: Re: ALPS touchpad with 4 directions button doesnt work as intended
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <1256955018.9681.23.camel@maxim-laptop>
References: <1256955018.9681.23.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 11:55:40 +0200
Message-ID: <1257846940.4921.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-31 at 04:10 +0200, Maxim Levitsky wrote: 
> I have a acer 5720G laptop, and its touchpad (ALPS) has three buttons,
> usual left/right, and middle button that can be pressed in 4 directions.
> Up/down direction work fine, but left/right doesn't. This means that
> left direction  produces middle button click, and right direction
> doesn't work at all.
> I took a look at source, and I see that driver doesn't even know about
> such configuration.
> 
> Now I am sure its very easy to figure out what is send when no working
> button is pressed, but I am a bit confused what BTN_* event to assign to
> it, so it will work as horizontal scroll as intended.
> And unassign middle button from other direction....

I have written now the patch to resolve this issue on my laptop.
However I had to put a dmi check for my system, because I afraid I break
others.

The problem is that the device reports 4way button in bizarre way, this
is it reports left way click as a middle button.

I can't test for laptops that really have just middle button and thus
reporting it as the left way scroll is wrong.

Testing for hardware version probably won't help, I am afraid that this
is laptop specific. Windows .INF file has plenty of suspicious entries
about that.

The ALPS touchpad on my notebook reports 0x73, 0x02, 0x50 for the
version.

Also up/down directions are now reported by BTN_0, BTN_1
Feel free to ask me not to do so if there is a reason to do so.
Here it works both ways.


Best regards,
Maxim Levitsky

