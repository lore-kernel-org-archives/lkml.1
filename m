Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab0BYWlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:41:36 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:44460 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab0BYWlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:41:35 -0500
Message-ID: <49e34e8ba40c44c622171868798f9919.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100225233250.241e7d6d@neptune.home>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
    <20100225233250.241e7d6d@neptune.home>
Date: Thu, 25 Feb 2010 15:41:21 -0700
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: Bruno =?iso-8859-1?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, npavel@ituner.com, tomi.valkeinen@nokia.com,
       tony@atomide.com, florianschandinat@gmx.de, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bruno Prémont wrote:
> On Thu, 25 February 2010 "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
> wrote:
>> This patch adds support for examining and modifying the fbdefio delay
>> parameter through sysfs. It also adds two driver definable minimum
>> and maximum bounds.
>>
>> The default behavior is to not permit modifications if delay_max is 0,
>> thus preventing modification of the delay if the driver does not
>> explicitly permit modification.
>>
>
> ...
>
>> @@ -503,6 +584,12 @@ static struct device_attribute device_attrs[] = {
>>  #ifdef CONFIG_FB_BACKLIGHT
>>  	__ATTR(bl_curve, S_IRUGO|S_IWUSR, show_bl_curve, store_bl_curve),
>>  #endif
>> +#ifdef CONFIG_FB_DEFERRED_IO
>> +	__ATTR(defio_delay, S_IRUGO|S_IWUSR,
>> +	       show_defio_delay, store_defio_delay),
>> +	__ATTR(defio_delay_min, S_IRUGO, show_defio_delay_min, NULL),
>> +	__ATTR(defio_delay_max, S_IRUGO, show_defio_delay_max, NULL),
>> +#endif
>>  };
>>
>>  int fb_init_device(struct fb_info *fb_info)
>
> Would it be reasonable to add these attributes in
> fb_deferred_io_init() and remove them in fb_deferred_io_cleanup()?
> This would also make it possible to add write permission to delay
> attribute only when it effectively can be modified.
>
> IMHO having only attributes pertinent to the features supported by the
> framebuffer is better than having all the possible ones and those of
> unsupported features returning -ENODEV.
>
> Bruno
>

I looked at that, but it seems like all the sysfs stuff has been
co-located in fbsysfs.c, so I tried to just follow the pattern of the
backlight code which takes the same approach.

-- 

Rick

