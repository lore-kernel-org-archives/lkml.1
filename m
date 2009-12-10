Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbZLJPRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbZLJPRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbZLJPRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:17:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62339 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760894AbZLJPRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:17:10 -0500
MIME-Version: 1.0
In-Reply-To: <20091210144920.GA27237@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> 
	<71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com> 
	<20091210024834.GB20410@suse.de> <1260455537.25352.1762.camel@jani-desktop> 
	<20091210144920.GA27237@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 10 Dec 2009 16:17:00 +0100
Message-ID: <ac3eb2510912100717p11e3c515l2d9155a764befc71@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under gpio 
	class directory
To: Greg KH <gregkh@suse.de>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 15:49, Greg KH <gregkh@suse.de> wrote:
> On Thu, Dec 10, 2009 at 04:32:17PM +0200, Jani Nikula wrote:
>> We simply decided to extend gpio_export_link(). When it is called
>> with 'dev == NULL' (no driver), it creates an additional symlink
>> in /sys/class/gpio/
>>
>> # ls -l /sys/class/gpio/
>> --w-------    1 root     0            4096 Jan  1 00:00 export
>> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 power_button -> ../../devices/virtual/gpio/gpio25
>> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio25 -> ../../devices/virtual/gpio/gpio25
>> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio38 -> ../../devices/virtual/gpio/gpio38
>> ...
>>
>> This is exactly what our patchset allows to do.
>>
>> An alternative would be a dummy driver just to create a home in sysfs
>> for the standalone GPIOs and use the gpio_export_link() to make the
>> links there.
>>
>> Any other suggestions?

We can not do anything like that. The symlink name must always match
the name in /sys/devices/, and it must be a 1:1 relation. We can not
allow anything else, it confuses tools which rightfully expect this.

You could convert the class to a "bus", the /sys/class layout is
pretty much broken by design, and should better be avoided. It's not
extensible, flat in its layout, and today just a too dumb version of
the "bus" subsystem which does not have all these limitations.

All the device links would show up in /sys/bus/gpio/devices/, here you
have the same rules as in /sys/class/: no additional symlinks, the
same names as in /sys/devices -- but you could add a custom folder to
the  /sys/bus/gpio/ directory where you could do whatever fits your
needs. :)

Thanks,
Kay
