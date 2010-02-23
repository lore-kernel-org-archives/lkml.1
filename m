Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0BWJ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:56:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37369 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BWJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:56:16 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 04:56:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Yprs06ZH2qtIwocIl/pY38wIkGuQnqSZ+ouvpoUp/b7y8GL2UepBjQHlKvRacjT3F2
         5aqLHC2Cc6sH5ZfeyuLUpo04ea/TXC7ebB1lJG4NpCqfw7BdbK499w4tsG2AORSvddQg
         kiMW5QBD8GD+W3af1hBDHW972bm8F7mxY4Xac=
Date: Tue, 23 Feb 2010 10:50:25 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: viresh kumar <viresh.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: QUERY: Inclusion of header files in kernel header files
Message-ID: <20100223095025.GA18559@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	viresh kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
 <20100223065953.GB32503@liondog.tnic>
 <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: viresh kumar <viresh.linux@gmail.com>
Date: Tue, Feb 23, 2010 at 01:01:25PM +0530

> >> Again, if i include device.h and resource.h, they must be included before bus.h.
> >
> > and this is the thing: all those other files which include
> > <linux/amba/bus.h> either include <linux/device.h> and
> > <linux/resource.h> directly or the last are being included indirectly
> > through other headers.
> >
> > Baseline, struct device and struct resource's definitions have to be
> > available before <linux/amba/bus.h> is included. That's why you have to
> > include the bus.h header last.
> >
> 
> We need to include device.h and resource.h at every place where we use bus.h.
> 
> Shouldn't it be responsibility of bus.h only? So that people don't
> have to bother about bus.h
> internal dependencies.

A quick grep in <include/linux/> reveals that most, if not all, of the
headers that use struct resource, for example, include ioport.h which
contains the definition. So yes, it should be like this, besides we
guard against multiple inclusion with the #ifndef ..., #define... #endif
thing anyway.

> I think, ideally including any header file shouldn't give compilation
> errors for types used in
> included header file.

Agreed.

I'd send a patch fixing the bus.h header, in case no one has a valid
technical reason against it.

-- 
Regards/Gruss,
    Boris.
