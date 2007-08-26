Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXHZQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXHZQtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXHZQt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:49:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:3248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbXHZQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rqcsdb0tyypHbn60ADYs+x+aV7UUcQXw7vUWAMI6OOFvJ1151oOZBNOjCUwAvX2Bdufq8rW1zaa5Lhua50rEJdmwwOH1qQV0AvVRURPHl5RGATyxKWpR46GYvVZHBl0dWq73TqjbM6+CJg9/FCEg5PYXDnbWOYnndwsLfpiGAvo=
Message-ID: <466ad3f90708260949i3b9d1c32ia8b1869196689247@mail.gmail.com>
Date: Sun, 26 Aug 2007 12:49:25 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: jengelh@computergmbh.de, linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
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
>
> >Ok, I did this on a non-production machine that has only been up for a
> >few hours, and here's what happened:
> > ...
> >So, I guess it worked? (I don't know what was supposed to happen, but
> >memory usage dropped significantly when I did this.)
>
> So I guess you are not seeing any memory leak at all, but just the regular
> caching?

I certainly hope that is the case, but until I try it on the
production machine tonight I won't know for sure. If this is indeed a
leak, it's pretty slow, and it takes a week or so before you can even
start noticing it on the graphs

I can say with absolute certainty that something very similar was
happening in 2.6.12 (compare the graphs in my original email), and in
2.6.12 it would inevitably lead to the server running entirely out of
memory, to the point where applications could no longer allocate
memory and the server would have to be rebooted.

The symptoms were almost identical in that case: I'd shut down
virtually every application on the server, but the memory would still
be almost entirely in use. I understand there's kernel caching, but if
the kernel caching occurs at the expense of any other applications
being able to access memory, then there's a real problem. (I actually
still have one 2.6.12 machine running, but drop_caches doesn't appear
to exist on it so I can't test it there. Is there an analogue?)

Anyway, I'll post the results from the 2.6.20 server as soon as I have
them. Should be late tonight.

Thanks.
