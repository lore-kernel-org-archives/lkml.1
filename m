Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXHZQ7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXHZQ7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbXHZQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:58:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:62839 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbXHZQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oEFganyfq3+ZAL0G2F6kQ1PRAImP6HKQ+Lm822yaT/9dBIsfuvY7DVmUh+M8Q632f4kVnANlug0MOaI2H1tygrr2oGsfQ26TSDjdS/D0iF4jCFuzziLis0v/KKd4XZqb34rmPFCX432tjUViZH5KVfMIMeMSPf6qmiX58NAf/xY=
Message-ID: <466ad3f90708260958ha149c40ncf5a8287c8a25307@mail.gmail.com>
Date: Sun, 26 Aug 2007 12:58:54 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Slow, persistent memory leak in 2.6.20
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708261828540.15614@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
	 <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com>
	 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr>
	 <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com>
	 <Pine.LNX.4.64.0708261828540.15614@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 26 2007 12:16, Fred Tyler wrote:
> >> Please rule out filesystem caches by issuing
> >>         sync;
> >>         echo 3 >/proc/sys/vm/drop_caches;
> >
> >
> >So, I guess it worked? (I don't know what was supposed to happen, but
> >memory usage dropped significantly when I did this.)
>
> So I guess you are not seeing any memory leak at all, but just the regular
> caching?

Also, how can you explain the differences between the graphs of
long-term memory usage? This first graph is from a server running
2.6.16 that never has memory problems:

    http://i239.photobucket.com/albums/ff117/fredty8/memory-a4.png

And here's a graph of a server running 2.6.12 that has to be rebooted
every month or two because it runs out of memory:

    http://i239.photobucket.com/albums/ff117/fredty8/memory-a2.png

Now, admittedly, the 2.6.20 server has not been running long enough to
know whether or not it's going to start starving applications of
memory, but the graph here looks a whole lot more like 2.6.12 than
2.6.16, wouldn't you agree:

    http://i239.photobucket.com/albums/ff117/fredty8/memory-b1.png


Those 2.6.12 servers caused me a ton of stress because I let the
problem go too long before I did anything. In the event that 2.6.20 is
doing the same thing, I'm trying to fix it before things get out of
control.
