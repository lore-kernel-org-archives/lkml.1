Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYGFPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYGFPIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYGFPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:08:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:52918 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbYGFPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y2f8iQNSqx8dUVWi6zCDNQ4CM3orwC+Qs5+LjBYuaNWfr9XEMQYxpxbjd7/gD0vT1k
         WkkblnBB9hn/FXIRD6H5cd6a/5YDMQm0aht7+dd/dfX+XaIn2ZtfSUPMqCTCG9OIkqFR
         vOjj/1kb9wqrX7+1tuDirjXpSpdgCyCNiKxq4=
Date: Sun, 6 Jul 2008 17:07:02 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706150608.GA5401@joi>
References: <20080705131924.GA2083@joi> <20080705235148.GW28946@ZenIV.linux.org.uk> <20080706001148.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706001148.GX28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 01:11:48AM +0100, Al Viro wrote:
> On Sun, Jul 06, 2008 at 12:51:48AM +0100, Al Viro wrote:
> 
> > I don't believe that it's right.  Note that if you *do* race there, you
> > are fucked regardless of sysctls - ppdev.c::register_device() racing
> > with itself will do tons of fun things all by itself (starting with two
> > threads allocating different pdev and both setting pp->pdev).

I wouldn't call it a race - BKL is protecting multiple ioctl calls, so we
won't ever claim the device from two different threads.

> BTW, with your patch you'll have 100% reproducible double registration if
> you do PPCLAIM/PPRELEASE/PPCLAIN on one file descriptor.

Yes, I didn't notice PPRELEASE ioctl (I thought releasing the device is
done during close()).
