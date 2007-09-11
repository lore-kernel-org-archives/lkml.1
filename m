Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbXIKOF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbXIKOF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbXIKOFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:05:51 -0400
Received: from zone4.gcu.info ([217.195.17.234]:54814 "EHLO
	zone4.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXIKOFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:05:50 -0400
Date: Tue, 11 Sep 2007 16:05:33 +0200 (CEST)
To: hmh@hmh.eng.br
Subject: Re: Platform device id
X-IlohaMail-Blah: khali@localhost
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <fk7FYVmE.1189519533.5546870.khali@localhost>
In-Reply-To: <20070911134405.GA18443@khazad-dum.debian.net>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "David Brownell" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 9/11/2007, "Henrique de Moraes Holschuh" <hmh@hmh.eng.br> wrote:
>On Tue, 11 Sep 2007, Jean Delvare wrote:
>> I don't know your code and I don't really have the time to look at it
>> in depth, but I'm a bit surprised. Presumably your driver is
>> implementing a number of interfaces (e.g. hwmon) and you create a class
>> device for each one. You can have as many class devices hanging of a
>> (physical) device, so I fail to see why you would need to register
>> several (physical) devices.
>
>Namespace clashes.  Now that class attributes are gone (or going, whatever),
>everything lives in one namespace: the device.  I dread the day I find out
>one class I need has attribute name clashes with another, or (more likely)
>one of my driver-specific attributes clash with one from a generic class.

This shouldn't be the case. Ex-class devices still have their own
directory in sysfs. For example, the radeonfb driver spawns 4 i2c buses
(i2c-adapter class), each gets its own directory.

One problem at the moment is the hwmon subsystem, because we create the
attributes in the physical device rather than in the hwmon class device.
This is for historical reasons, but I presume that we'll have to change
this someday to work around the name space collision issue you
mentioned. If other subsystems are doing the same mistake, this can
explain your problem, but this is a subsystem implementation issue, not
a problem with class devices themselves.

>Even if clashes never happen, it can make quite a mess when you have four or
>more classes in the same device.

I don't agree. This is how things were designed.

>And you can have semanthic clashes, if one
>looks at various attributes (from different classes or driver-specific) and
>think they are related in some obvious way (only, it is not obvious at all,
>and the user didn't read the docs to know it).

There's really no reason why you would be randomly poking at attributes
without knowing which class device they belong to.

--
Jean Delvare
