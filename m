Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYEWMVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYEWMVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 08:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYEWMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 08:20:52 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:25314 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYEWMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 08:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z7cpjTWKhFZHVXD3/V8yPLABjhTOqknhoojm8NIWzav4cjbs1wbD13t/LDaOcQrw8ift6KahW1UyYiCcYos+9MoW3G7BH4HpmvcRquOgbM3DC7UanE+KqFsqfPaqbHCJd6hTYCEXe4dcHZrIrystbNEj0awzCQ8g5M5fMmFw0Ws=
Message-ID: <7b9198260805230520t46d79d9bqceabf4691388e89d@mail.gmail.com>
Date: Fri, 23 May 2008 13:20:50 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080523141432.13dc9212@bluebox.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
	 <20080522200814.GD3226@local>
	 <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
	 <20080523054115.GB28807@digi.com>
	 <7b9198260805230448x56bf3bd1kade6083c141a75f2@mail.gmail.com>
	 <20080523115815.GA6932@digi.com>
	 <7b9198260805230500l6b21a397m6951a2b1115a6f5@mail.gmail.com>
	 <20080523141432.13dc9212@bluebox.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/23 Hans J. Koch <hjk@linutronix.de>:
> Am Fri, 23 May 2008 13:00:17 +0100
> schrieb "Tom Spink" <tspink@gmail.com>:
>
>> My initial idea was just a thought anyway, just to
>> maintain a bit of extensibility if .write is ever needed for something
>> else. :-)
>
> Hi Tom,
> thanks for your contribution, but for me it's just the other way round:
> I'm glad write() gets a defined purpose before people do something
> stupid with it. It's good to remember that all data exchange with the
> device has to be done through the mapped memory. If this is not
> possible, the hardware is no candidate for a UIO driver.
>
> BTW, I wait for the first UIO driver which abuses this write()
> function to write many different values to trigger different actions.
> I wonder if I should restrict write() to the value 0 and 1...
>
> Thanks,
> Hans

Hi Hans,

Thanks for your explanation.  Another thing, I noticed then, is that
in your return statement, you blindly return the the value of
irqcontrol if it's non-zero, and if it's zero, then the length of the
data written.  However, if irqcontrol returns a value that's > 0, it
could potentially confuse writers.  I guess it's up to the implementer
of irqcontrol to ensure they stick to -EXXX and 0, but it's just a
thought (while you were on the subject of input validation!)

-- 
Tom Spink
