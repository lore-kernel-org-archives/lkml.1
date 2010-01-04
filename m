Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847Ab0ADWrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0ADWrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374Ab0ADWrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:47:46 -0500
Received: from www84.your-server.de ([213.133.104.84]:55222 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0ADWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:47:45 -0500
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
From: Stefani Seibold <stefani@seibold.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100104222429.6a386a88@lxorguk.ukuu.org.uk>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210314.ABA04B17C3@basil.firstfloor.org>
	 <1261950589.25298.32.camel@wall-e> <20091227234137.GD2399@basil.fritz.box>
	 <20100104135754.07d4e442.akpm@linux-foundation.org>
	 <20100104222429.6a386a88@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 04 Jan 2010 23:47:39 +0100
Message-ID: <1262645259.6469.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 04.01.2010, 22:24 +0000 schrieb Alan Cox:
> > Macros are unpopular, for good reasons.  But the case for a
> > template-based container such as this is a good one.  However I worry
> > about the code bloat whcih the macro version might add.  We worry about
> > all this later on.
> 
> Its really a special case for structs and fixed objects.
> 
> Bloat is going to be a big issue if its macro and all the serial/tty
> stuff switches to it. Please keep the bytewise one none macro - even if
> its a lib/foo.c file that simply uses the macros to produce the existing
> new API.

Nope, currently the bytewise is the special case. Most of the user of
kfifo try to store other type then bytes in a fifo. 

The new macro based kfifo does not bloat the code, the opposite is the
truth. I checked the assembler output on intel and ppc and the generated
code is smaller and better.

The macro are written in a way that you get a useful single line compile
time error message.

Also "the power of two" thing will make the kfifo not very useable to
handle not multiple of 2 datas, in a fifo.

At last a type safe kfifo is 100% compatible to the current kfifo if the
the is a "unsigned char".

It would be better to discuss this in the "[PATCH] new kfifo API v.08"
threat from 28.12.2009.

Regards,
Stefani


