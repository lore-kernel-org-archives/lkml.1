Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYEWIwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYEWIwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYEWIwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:52:11 -0400
Received: from www.tglx.de ([62.245.132.106]:47241 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYEWIwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:52:09 -0400
Date: Fri, 23 May 2008 10:51:53 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: Tom Spink <tspink@gmail.com>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
Message-ID: <20080523105153.2704a939@bluebox.local>
In-Reply-To: <20080523054115.GB28807@digi.com>
References: <20080522192252.GB3226@local>
	<20080522192637.GC3226@local>
	<7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
	<20080522200814.GD3226@local>
	<7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
	<20080523054115.GB28807@digi.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 23 May 2008 07:41:15 +0200
schrieb Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:

> Hello Tom,
> 
> Tom Spink wrote:
> > The added benefit is that the code becomes less complex, as you
> > don't have to check buffer sizes and copy the integer from
> > userspace.
> AFAIK this is wrong.  You need to copy the integer from userspace in
> uio_ioctl.  Actually it's a value coming from user space, so you need
> to do it somewhere.

True. Also note that this is not type-safe. All ioctl calls blindly
trust userspace to pass in correct data. This has to be tolerated for
ancient well-known filesystem ioctls, because you'd break almost all of
userspace if you changed that, but we certainly don't want to add new
stuff to this mess.

Thanks,
Hans

