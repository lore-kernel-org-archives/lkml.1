Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYANNDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYANNDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbYANNDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:03:31 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:36150 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYANNDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iveO7Ig3Nky4cfQbMfF3y26lAvgUrxyQyfc1+Po7MXDIOud3R9MLRSGi+3qu7N279YE8+N5+nLF5gzN/x/g4ba3CmLE4i5162ISVIiQC59rBH3oP/UzYHN86/8VWT+TejN7L/MtrIJBf1i7N7TGqEjkdSANdssFuVq6uP5jWWzE=
Message-ID: <8bd0f97a0801140503t484ab61clcf41f4e4ea913fe4@mail.gmail.com>
Date: Mon, 14 Jan 2008 08:03:29 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [RFC, PATCH] watchdog on gpio
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Marc Pignat" <marc.pignat@hevs.ch>,
       wim@iguana.be, linux-kernel@vger.kernel.org
In-Reply-To: <87zlv8k1w0.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101611.08867.marc.pignat@hevs.ch>
	 <8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	 <20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	 <8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	 <20080114092905.227c5a38@lxorguk.ukuu.org.uk>
	 <8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
	 <87zlv8k1w0.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 7:49 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> "Mike Frysinger" <vapier.adi@gmail.com> writes:
> > wonder if we could design a printk designed for __init functions to
> > address this in a clean fashion.
> > #define init_printk(fmt, __VA_ARGS__) \
> >   do { \
> >     static const __init char __fmt[] = fmt; \
> >     printk(__fmt , ## __VA_ARGS__); \
> >   } while (0)
> >
> > (yes, i know this isnt perfect as you'd need to pass back the return
> > value of printk(), but it's an idea)
>
> How about:
>
> #define init_printk(fmt, args...) ({            \
>         static const __init char __fmt[] = fmt; \
>         printk(__fmt, args);                    \
> })
>
> Now it returns the printk result.

i wasnt really worried about that ... i was worried about other random
things i may have missed

your dropping of ## wont work as you need gcc to expand args and take
away the , in the simple 1 arg case:
init_printk("MOO");
-mike
