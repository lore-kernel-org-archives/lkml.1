Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZAGPWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZAGPWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZAGPWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:22:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:64605 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZAGPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:22:14 -0500
Message-ID: <9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
Date: Wed, 7 Jan 2009 07:22:12 -0800
From: "Ed Swierk" <eswierk@aristanetworks.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Cc: linux-i2c@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "Alessandro Zummo" <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "BARRE Sebastien" <sbarre@sdelcc.com>
In-Reply-To: <20090107142426.4be04d4d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231177261.13443.20.camel@localhost.localdomain>
	 <20090107142426.4be04d4d@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 5:24 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Are you certain the nForce2 controllers can't do it? The i2c-nforce2
> driver doesn't implement it, but this doesn't mean the hardware can't
> do it. I don't have any datasheet for these chips, but I know their
> SMBus implementation is very similar to those of the AMD 8111, and
> i2c-amd8111 has support for I2C block reads and writes. I think it
> would be worth giving it a try, by copying the i2c-amd8111
> implementation into the i2c-nforce2 driver and seeing if it happens to
> just work. If it works, that would be more elegant than your proposed
> hack to the rtc-ds1307 driver.

I checked the datasheet and also tried every possible SMBus command
value to try to discover any supported commands that the i2c-nforce2
driver happens not to use, to no avail. The nVidia SMBus is pure
SMBus.

I could change the ds1307 driver to check whether the controller
supports i2c block commands and fall back to emulation only if they
are not available. Would that address your concerns?

--Ed
