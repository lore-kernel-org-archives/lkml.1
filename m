Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbZJIQf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbZJIQf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933904AbZJIQf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:35:58 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36658 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbZJIQf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=EeMpbyqNhbEapztzFd+7iZD+nFLp7UocGmbG5vRzgF3M7XFJtJVcqd6FAQjGq9Arjt
         4+sCA/gNZxsa1ZtBsWN5L9NLBVWmUskHFS7KwOGR9eBCPEGbOWIe/R+iNb529tgftRG8
         QVo3U8AXdht4ifd0L7Vlj/PyM4nbOybyXd1uw=
Date: Fri, 9 Oct 2009 09:35:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: ads7846 touchscreen: fix pressure
Message-ID: <20091009163506.GE1092@core.coreip.homeip.net>
References: <20091006195413.GA1469@ucw.cz> <5d5443650910072209t63e3fa9dvff7ab2fee7bb2f88@mail.gmail.com> <20091008092433.GA26837@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091008092433.GA26837@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 11:24:33AM +0200, Pavel Machek wrote:
> On Thu 2009-10-08 10:39:39, Trilok Soni wrote:
> > Hi Pavel,
> > 
> > On Wed, Oct 7, 2009 at 1:24 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > >
> > > On Zaurus, pressure is reported inverted -- the lighter the pressure,
> > > the bigger numerical value. This should fix it.
> > >
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >
> > > --- linux-rc/drivers/input.ofic/touchscreen/ads7846.c   2009-10-06 13:49:56.000000000 +0200
> > > +++ linux-rc/drivers/input/touchscreen/ads7846.c        2009-10-06 21:18:25.000000000 +0200
> > > @@ -608,12 +609,12 @@
> > >
> > >                input_report_abs(input, ABS_X, x);
> > >                input_report_abs(input, ABS_Y, y);
> > > -               input_report_abs(input, ABS_PRESSURE, Rt);
> > > +               input_report_abs(input, ABS_PRESSURE, ts->pressure_max-Rt);
> > 
> > but same behavior is seen by others using this chip on different
> > boards? If not, this has to be done through platform data.
> 
> Well, I'd expect the chip to behave in similar way on all
> platforms. Of course, it would be good if someone with different hw
> tested it, but I do not have that hw...
> 
> So I guess the best way is to make it go in early and see how it does
> in testing....

No, this is not how it works. Please do

	git log -- drivers/input/touchscreen/ads7846.c

and try to check with people who were working on this driver. I somehow
doubt that they'd overlook such obvious issue as inverted pressure
readings.

-- 
Dmitry
