Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbYDEDVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbYDEDVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 23:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYDEDVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 23:21:10 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:22836 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751241AbYDEDVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 23:21:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Dggf3fbFcjkRKd9SwvrOiY+Yc/5+6zMH94lLyiKcEcCguZVLgUKJcEd1VB2rhG0AHdsySNBPpJx7WyU+vjd5dH1vJYIju2iowEmxf3T1jRdidqlmpnFPkund80W08BHYtgyPXw97AI+Vzw0mZOTtIQ1L/VbSG5T4QNYiNvDlCu4=  ;
X-YMail-OSG: 8Y80SaQVM1kK5vMALMLGhe3CAYdU5pc.FGfc054TrtmW1._se3JAx9GykIhg.jinoYeRMCo0CQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Date: Fri, 4 Apr 2008 19:51:24 -0700
User-Agent: KMail/1.9.6
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200710291809.29936.david-b@pacbell.net> <20080404100933.077bee33@hyperion.delvare> <Pine.LNX.4.64.0804041102230.20532@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804041102230.20532@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804041951.24653.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Trent Piepho wrote:
> >> +    if (test_bit(FLAG_IS_OUT, &gdesc->flags)) {
> >> +            return -EINVAL;
> >> +            /* strcpy(buf, "-1\n"); return 4; */ /* Or this? */
> >
> > Why not just return gpio_get_value(n) in all cases?

That's the right answer...


> > User might want to 
> > know which value is currently being output.
> 
> I thought the gpiolib layer didn't let you read an output, but I see that's
> not the case now.  Maybe it's changed since the first revision?  I've changed
> this to call gpio_get_value(n) for outputs too.

I don't recall ever disallowing reading output values ... the
exact behavior is platform-specific, though it "should" be the
value actually sensed at the pin, which might not be the same
as what's being driven.


> Though for the MPC8572 GPIO driver I wrote, it doesn't support reading
> outputs.  The hardware doesn't allow it (IMHO, a design flaw), and working
> around this significantly slows down GPIO functions.

Then don't worry about it.  Any portable code can't rely on
being able to do that.

- Dave


> What I'm trying to do 
> with the GPIO lines is going to be slower than desired no matter how fast I
> make the gpio code (which is almost entirely responsible for the final speed),
> so slowing down reads by a factor of four or more just to read back outputs
> isn't desirable.
> 


