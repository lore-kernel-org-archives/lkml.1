Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZJLEgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZJLEgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 00:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZJLEgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 00:36:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:7807 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZJLEgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 00:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tRv6m6gj88TAI1+hMfDbc1R2TfsWtHRsAuSfByeRtyitqicow6KvlQ9Qfvf3wfnhLs
         JSrw1IZgvzzMt074YBREE0x84gsSf4b1bYyBLPBTz/GHzjK7gCf4b/3Xv8JVBEvOzj0v
         J4S5JmTNjGLLoyJmspNUQWJzNg/WRocC3xzl8=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work anymore
Date: Sun, 11 Oct 2009 21:35:29 -0700
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3; KDE/4.3.1; x86_64; ; )
Cc: "?ric Piel" <Eric.Piel@tremplin-utc.net>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de>
In-Reply-To: <20091011030029.GA6526@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910112135.29384.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009 08:00:29 pm Greg KH wrote:
> On Sun, Oct 11, 2009 at 02:04:02AM +0200, ?ric Piel wrote:
> > Hello,
> >
> > After a suspend, I used to do this (to get the PS2 keyboard working
> > again), and it used to work fine:
> > echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind ; sleep 1 ; echo
> > -n "i8042" > /sys/bus/platform/drivers/i8042/bind
> >
> > Unfortunately since 2.6.32-rc1, the unbind works fine, but the bind
> > returns a "no such device" error now (and the binding is not done). After
> > that, additional unbinds also report the error. I think 2.6.31 worked
> > fine. Any idea what's going wrong?
> 
> Odd.  Any chance you can run 'git bisect' to figure out which patch
> might have caused it?

I8042 has been converted to use platform_driver_probe() - we are creating 
platform device and platform driver together, there is no chance that some 
other device might be driven by i8042 driver.

Eric, do you still need to fiddle with i8042 to get your keyboard working with 
2.6.32-rc3? We need to make sure that resube works without users needing to 
mess with bind/unbind.

-- 
Dmitry
