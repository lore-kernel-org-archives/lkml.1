Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZILJRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZILJRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 05:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZILJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 05:17:42 -0400
Received: from poutre.nerim.net ([62.4.16.124]:52699 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZILJRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 05:17:41 -0400
Date: Sat, 12 Sep 2009 11:12:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kari Laine <klaine8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: I2C -bus programming
Message-ID: <20090912111226.1bd13542@hyperion.delvare>
In-Reply-To: <4A854936.5060409@gmail.com>
References: <4A8491E3.4070907@gmail.com>
	<4A854936.5060409@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kari,

Kari Laine wrote:
> this is my first post here and I am not sure if this is a suitable topic
> here. Anyway I have a Velleman K8000 IO-card and it uses I2C over
> parallel port to communicate.
>
> when I modprobe i2c-parport it does not complain. I tested without card
> connected and it complained so it seems to find the card.

This doesn't mean the card is handled properly. You must pass the
proper card type parameter. The Velleman K8000 is type 2, so:

modprobe i2c-parport type=2

Alternatively you can add:

options i2c-parport type=2

to /etc/modprobe.conf or whatever modprobe configuration file your
system uses.

You didn't tell which kernel you are using, but kernel 2.6.17 and later
wouldn't let you load i2c-parport without a type parameter.

> modprobe pcf8591
>
> modprobe i2c-core
>
> modprobe i2c-dev
>
> I am not sure I am doing it right. Should i2c-core probed first ?

It doesn't matter. i2c-core gets loaded automatically when any other
module needs it.

> anyway now I have
>
> /dev/i2c-0  /dev/i2c-1
>
> Now I don't know whether these i2c-devices refer to this Velleman  board
> or some other i2c-device which happen to be in the computer...

You should install i2c-tools and use the command "i2cdetect -l". This
will tell you what each i2c bus on your system is.

Then you can try "i2cdetect <n>" where <n> is a bus number, to scan the
bus in question. This is a good way to test whether the driver and
device are working properly.

> If these devices probably refer to Velleman - then how I can refer
> different i2c-devices on the board.

Depends on the device. In the case of the Philips PCF8591, which
apparently you are using, sysfs attributes will be created somewhere
under /sys/bus/i2c/drivers/pcf8591. Each device has a name of the form
<bus number>-<device address>, for example "1-0048" for a PCF8591.

The sysfs attributes in question are described in
Documentation/hwmon/pcf8591 (or Documentation/i2c/chips/pcf8591 on
kernels older than 2.6.30.)

Hope this helps,
-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
