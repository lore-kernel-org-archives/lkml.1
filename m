Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYI2RVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYI2RVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYI2RVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:21:36 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:32421 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751733AbYI2RVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:21:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k3rwr8zrUFhTHaoVMLd2ng2mGKkBhtrUJlFimYUtBABuzt81+S7su7ANXTyF+exMD+oIIGlNBfG1M/J0fTfUNXxIyYptnLSJuw/gz2TE71+rIZTJfo014bXos979zlwVidpG0LdQLVV+qZQrhWoF5ETGzGTtaXoPcyE5Uh+jz1Q=  ;
X-YMail-OSG: 4PaoM80VM1mOawhtppSjA3Uv_Ihxs8UHZ9VNJZRQsPWGtXK8iF1GuqEJ4qpo6s7it2HDvYVLiuJVJEus6gXVpL.CnCOYw7Cw3q2bEAHFZS6V7GpGe5hQLzxPElmyxi9WvjU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [patch 2.6.27-rc7] gpiolib: request/free hooks
Date: Mon, 29 Sep 2008 10:21:29 -0700
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <200809241508.11091.david-b@pacbell.net> <200809271129.07241.david-b@pacbell.net> <aec7e5c30809282048x3d9a201j12303091e9d93a49@mail.gmail.com>
In-Reply-To: <aec7e5c30809282048x3d9a201j12303091e9d93a49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809291021.30655.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2008, Magnus Damm wrote:
> Hm, sounds like you prefer to keep pinmuxing and GPIO code separated?

Yep.

> > If you do that, be ready to provide a pinmux-only interface
> > at some point when this "piggybacking" breaks something...
> 
> In the SuperH case GPIO pin direction selection is done in the same
> way as selecting pin function. So in and out directions can be seen as
> two pin functions. And since we want to support GPIO pin direction we
> may as well support setting pin functions as well.
> 
> But maybe there are better ways to integrate it, I'm not sure.

Just don't expect the GPIO framework to address the problem of
how to configure one of those pins for a non-GPIO function.

Such pinmux problems deserve different programming interfaces.

\
> > Yeah.  Better to test-and-set the flag and then request, and backout
> > if it fails, than the other way.  Just who wrote that crap in the
> > first place?  Sigh.  (Notice it's done that way already in the code
> > path handling implicit requesting ... )
> 
> Sounds good.
> 
> > I'll send an updated patch along soonish.
> 
> Thank you!

... after I come up with a happy fix for the locking goofs;
those new methods may not be called under spinlock protection.

- Dave
