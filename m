Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYFJRtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYFJRtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYFJRsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:48:55 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:49487 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYFJRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:48:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvBYAEpbTkhV5CFwPGdsb2JhbACBW4FKh36GYwEBAQEtnjE
Date: Tue, 10 Jun 2008 19:48:50 +0200
From: Martin Samuelsson <sam.linux.kernel@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben@fluff.org>, linux-dvb@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: Multiple Zoran MJPEG cards and i2c misattachments
Message-Id: <20080610194850.71b30d73.sam.linux.kernel@gmail.com>
In-Reply-To: <20080609085110.65de75ae@hyperion.delvare>
References: <5a8e970805311139r1355cfccy6933605f7b6441b6@mail.gmail.com>
	<20080601212837.GA10699@fluff.org.uk>
	<20080602113237.e6094cfd.sam.linux.kernel@gmail.com>
	<20080609085110.65de75ae@hyperion.delvare>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 08:51:10 +0200
Jean Delvare <khali@linux-fr.org> wrote:

Hi, Jean!
 
> > I'd say yes, they do. zoran_card.c contain lists detailing chips, and those
> > are available for reference at bus creation time. Would you know of any
> > driver I can look at to see how this new style stuff works? The "new style"
> > i2c things I've encountered so far is the 2.6 i2c subsystem as used when 2.4
> > style drivers are converted with a minimum amount of work involved.
> 
> "New-style" i2c drivers are drivers which follow the device driver
> model and do not create their own devices (i2c_client). As opposed to
> "legacy" i2c drivers in 2.4 kernels and early 2.6 kernels (and still a
> lot of drivers in the current 2.6 kernel) which create their own
> i2c_client.

That explains things. Good, then that should be the route to take.

> Ben wrote a guide about converting legacy drivers to new-style drivers:
>   http://marc.info/?l=i2c&m=121250094017709&w=2

Excellent, it looks simple enough.

> If you want to go that route for the zoran driver, you'll have to
> convert some of the chip drivers (at least bt866 and saa7185 if they
> are the ones causing trouble), and also modify the main zoran driver to
> create these devices (using i2c_new_device or i2c_new_probed_device) and
> remove them (using i2c_unregister_device) as needed.

bt866 belongs to the avs6eyes part of the zoran driver, while saa7185 belongs to the buz one.

> One problem may be if some of the chip drivers are shared with other
> V4L adapters (apparently the bt866 driver is zoran-only, but I'm not
> sure about the saa7185 driver). In that case you can't just convert
> them to new-style, or you would break the other adapters which expect
> the legacy drivers. So you'd have to make hybrid chip drivers, keeping
> the legacy driver (for other adapters) and adding a new-style driver
> (for zoran.)
> 
> In that case, you probably want to look at what Hans Verkuil did for
> the ivtv and cx18 adapters, and maybe talk to him. He wrote helper
> wrappers to write such hybrid chip drivers easily.

That sounds good, too. Breaking other people's drivers isn't nice.

> Note that I have a DC10+ somewhere in a drawer, so if you're going to
> convert the zoran drivers to the new-style model, I can help you with
> testing. And if you have questions in the process, feel free to ask.
> I'll be happy to review your patches.

Very good indeed. I'd work on some other chips, too, but there should be people that can test those not on the DC10+.

> P.S.: I don't know how much energy you are going to put in the zoran
> driver, but I have a number of patches for it, which never made it
> upstream, if you're interested.

I'm not going to commit myself to it full time. Not even half time or anything resembling that, because I seldom get away from life long enough for serious hacking. Zoran improvements are good, though, and if you don't have the time to commit them, I might do.

Regards,
/Sam
