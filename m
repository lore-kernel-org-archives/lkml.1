Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYFYXFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYFYXFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYFYXEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:04:53 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30184 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751072AbYFYXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:04:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=s3nsyBBg4bpOFnH6upkd+Uhni0uwt7tNo9TOJ8tDCdPn00los0OiIlnU69whcPerJxobJxg0rzMTd0MkWxtaxObK5l3kVt9egXxVKW8Y+Kgveb0ExBCK2WpbVNHvY8x3GU4VbgLM/IE8A6VU7ZdFDNtzzBMAryX/uNK/Pab+mBs=  ;
X-YMail-OSG: 2vqQWTgVM1n7pJZQwYK5Pq07We73msX04ywKbtp6AYFd0jvY_G9PsVd.W5ydUk07tdkk0Ie5.isO_gveAjMD7Py9_hKRR1IGWnWTQ7.nQRqB.X43xEuG45XPuyUmbytHE68-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] rtc: remove BKL for ioctl()
Date: Wed, 25 Jun 2008 16:04:49 -0700
User-Agent: KMail/1.9.9
Cc: Jonathan Corbet <corbet@lwn.net>, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
References: <200806221955.42597.david-b@pacbell.net> <20080625163928.4da1f4a0@bike.lwn.net> <20080625233017.5b207e94@lxorguk.ukuu.org.uk>
In-Reply-To: <20080625233017.5b207e94@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251604.49995.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008, Alan Cox wrote:
> > 
> > Shouldn't that be -EINTR?
> 
> For an ioctl case which should never be blocking for long periods it
> shouldn't be _interruptible in the first place, that will just introduce
> bizarre and weird bugs in application code.
> 
> If there are slow ops they should drop and retake the lock.

What's a "long period"?

RTCs that connect using I2C or SPI will need to queue for access to
that particular serial bus, and then there are transfer costs.
The busses are frequently, but of course not always, idle.  For I2C
at 100 KHz, RTC transfers might take a millisecond or so.

I'd be tempted to say those are all quick enough that the ops don't
need to be interruptible.

- Dave
