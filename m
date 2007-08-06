Return-Path: <linux-kernel-owner+w=401wt.eu-S1764659AbXHFRQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764659AbXHFRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXHFRQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:16:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:57017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbXHFRQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:16:48 -0400
In-Reply-To: <46B07F04.8040806@ru.mvista.com>
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <46A79DE0.8060405@ru.mvista.com> <46A79F14.9040409@freescale.com> <46A7A17C.8090505@ru.mvista.com> <46A7A1D5.7020003@freescale.com> <46A7A5E4.4090105@ru.mvista.com> <d04530fcd6e879e0bc059049b7951aef@kernel.crashing.org> <46B07F04.8040806@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <ef909c9835ecc57be4f4fa7fdc405889@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver
Date: Mon, 6 Aug 2007 19:16:27 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> More importantly, "reg-shift" doesn't say what part of
>> the bigger words to access.  A common example is byte-wide
>> registers on a 32-bit-only bus; it's about 50%-50% between
>> connecting the registers to the low byte vs. connecting it
>> to the byte with the lowest address.
>
>    We already have "big-endian" prop used in MPIC nodes, IIRC. Could 
> try to "reuse" it here as well...

Sure.  This would be an okay way to handle legacy devices that
are connected in inventive ways: add "reg-shift" and/or "big-endian"
properties.  We should make sure this is documented in the
appropriate bindings though, don't just assume it will work.

For non-legacy devices, please just use the "compatible"
property to figure out the endianness etc.; it is a bad idea
to make a "blablabla-big-endian" compatible value, but you can
almost often just use a more specific model name instead; and
typically the device has some other quirks anyway ;-)

>> It would be nice to not name similar properties in the
>> device tree dissimilarly.  Kernel code doesn't come into
>> the picture here.
>
>    The "reg-shift" prop is yet unaccepted ad-hockery at this point. ;-)
>    So, I don't see why we have to be consistent with it.

Don't treat your ad-hockery ad hoc, that way leads to insanity :-)

It's quite important to use good names for all new properties
you define, so you naturally end up with similar names for
similar purposes.  Of course it isn't a *requirement*, you're
right about that.


Segher

