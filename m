Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXFLNph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXFLNph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXFLNpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:45:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:2758 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXFLNpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZyVs3bm3KtY5Q0nMo0NjNYWWbcMNqhnJzaegtwskcJ394dg68Ms4sSTPIpW+uRofPtH2vWk7V1HLGiMrDKd1FWkZuzt9YIbs86X1hLZBmjFfmStMApGEfpRriYWm2LInkYp0lrvFphATxJv5/Mq1hJN4VBNYG96issgTcCYC57U=
Message-ID: <d120d5000706120645w48f784cdt22c6c0a707166325@mail.gmail.com>
Date: Tue, 12 Jun 2007 09:45:29 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Renato Golin" <rengolin@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
	 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
	 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
	 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
	 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
	 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
	 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com>
	 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Renato Golin <rengolin@gmail.com> wrote:
> On 12/06/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > We need to find out why you see [-127, 127] range, because if joydev
> > would see [0, 4096] range it would perform automatic correction and
> > map values like this:
> >
> > c0: 2048, c1: 2048, c2: 262144, c3: 262144
>
> Hi Dmitry,
>
> That's the values I got *after* calibration. Before, because the
> correction is set to a small signed value, it corrects wrongly and
> report a random mix of signed and unsigned values when moving in one
> direction...
>

Yes, if correction was calculated for [127; 127] range and the device
would feed [0; 4096] it would of course produce wrong results.


>
> > Which is fine as far as I can see. What utility did you use that
> > reported [-127; 127] range?
>
> At joydev_connect, the last parameter "input_dev" reports me that
> range (dev->absmax[i] and dev->absmin[i]). When I turned on HID_DEBUG
> it reported [0, 4096] for both axis 0 and 1, which is correct so it
> must be between HID and joydev.
>

Any change you could locate and run "evtest" utility and post its results?

> My point is that the auto-calibration could automagically solve all
> range problems in all devices by zeroing the range and adapting the
> ranges afterwards. If it can affect other devices as well as
> joysticks, the calibration could happen in HID instead of joydev.
>

We do not want to fix only joydev as it leaves other nput handlers
(for example access through evdev) still broken. That's why I want to
figure out where [0;4096] is being changed to [-127; 127].

-- 
Dmitry
