Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYCEXlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYCEXlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYCEXlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:41:01 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:46186 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756860AbYCEXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:41:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JkCdqEwddBt/o1UiUFlIFzsYxKwmHegkdzg1AB9SlDiNojEyqUrZAVNRdf5jvUKV6UWBGCDUw67DES3qHeGKas7Qr2NGNVgUGlLFOhQdNbelriRUnjUhVv6jFaj7np39/cJi0pLzYAthU4L6ybcdcFj2WBzpQ3ndrquIVEbIQi4=  ;
X-YMail-OSG: 0Ihicg0VM1mIqO0FsDZKNj0HEoKLfA2q0uTPwv6Dl2YSoM8o
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] gpiolib: implement dynamic base allocation
Date: Wed, 5 Mar 2008 15:40:57 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080304170307.GA29979@localhost.localdomain> <20080305152450.167c9e8c.akpm@linux-foundation.org>
In-Reply-To: <20080305152450.167c9e8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051540.57499.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Andrew Morton wrote:
> On Tue, 4 Mar 2008 20:03:07 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > If gpio_chip->base is negative during registration, gpiolib requests
> > dynamic base allocation. This is useful for devices being registered
> > at run-time (in contrast to platform devices).
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> >  drivers/gpio/gpiolib.c |   42 ++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 36 insertions(+), 6 deletions(-)
> > 
> 
> This conflicts in non-trivial ways with gpio-define-gpio_is_valid.patch. 
> Could you please redo and retest against 2.6.25-rc3-mm1?

And when you do that, could you make it assign GPIO numbers from
the biggest number on down, instead of from the smallest on up?

Platforms normally assign those numbers from the bottom up ... so
dynamic assignment should try to avoid reusing any numbers that may
have been explicitly assigned, but not yet registered.  (Of course,
if you can come up with a cleaner solution than that, it'd be great.
Maybe platforms should also be able to mark ranges as "in use" as
they start up, or something.)

And please add a pr_debug level message reporting dynamically
assigned ranges.  That way, when problems crop up it'll be that
much easier to notice what went wrong.

- Dave

