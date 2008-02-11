Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYBKXju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYBKXju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYBKXjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:39:43 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:1734 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbYBKXjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:39:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mcvu5lEkQ77pUebmfsSd1JCcm1sZudKLdnWteeI1sSF+4YMX0lcL4a9d6t6hhJVXMs5oZieGGliSwEFEDYSqug8zwVECyj+am1TZv+KPPWSpVaUk7Szfs8aZMU527mdhmLn0OPI+RQ21avlQn7EkJNoQt12YCQkuBzo7QtoZw8I=
Message-ID: <86802c440802111539w7eeb84dcu97103733364f7a7b@mail.gmail.com>
Date: Mon, 11 Feb 2008 15:39:39 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: (adm1026) Properly terminate sysfs groups (Was: panic about sysfs with adm1026)
Cc: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, "Mark M. Hoffman" <mhoffman@lightlink.com>
In-Reply-To: <20080210190115.2ebd4124@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440802092355l7393fe07gfbd021e9cef66181@mail.gmail.com>
	 <20080210171004.GB25353@kroah.com>
	 <20080210190115.2ebd4124@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 10:01 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sun, 10 Feb 2008 09:10:04 -0800, Greg KH wrote:
> > On Sat, Feb 09, 2008 at 11:55:43PM -0800, Yinghai Lu wrote:
> > > Calling initcall 0xffffffff80c4b575: sm_adm1026_init+0x0/0xe()
> > > i2c-adapter i2c-1: : Unrecognized stepping 0x45. Defaulting to ADM1026.
> > > general protection fault: 0000 [1] SMP
> > > CPU 0
> > > Modules linked in:
> > > Pid: 1, comm: swapper Not tainted 2.6.24-smp-09379-g0cf975e-dirty #34
> > > RIP: 0010:[<ffffffff802d79ad>]  [<ffffffff802d79ad>] sysfs_add_file+0x16/0x81
> > > RSP: 0000:ffff81040503dd50  EFLAGS: 00010286
> > > RAX: 0000000000000000 RBX: fffe002e002d002c RCX: 00000000000048d9
> > > RDX: 0000000000000002 RSI: fffe002e002d002c RDI: ffff810202c4fb90
> > > RBP: 0000000000000000 R08: ffff810202c4fb90 R09: 0000000000000000
> > > R10: 0000000000000002 R11: 0000000000000002 R12: 00000000fffffff4
> > > R13: ffff810202c4fb90 R14: 000000000000000c R15: ffff810202c4fb90
> > > FS:  0000000000000000(0000) GS:ffffffff80bde000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > CR2: 00007fff94de3470 CR3: 0000000000201000 CR4: 00000000000006e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process swapper (pid: 1, threadinfo ffff81040503c000, task ffff810205040000)
> > > Stack:  ffff810202c4fb90 0000000000000000 0000000000000000 0000000000000001
> > >  ffff810202c4e000 ffffffff80b87850 0000000000000000 ffff810202c4e118
> > >  ffffffff808e0cc0 ffffffff802d933c ffff81040503dd55 ffff810202c17878
> > > Call Trace:
> > >  [<ffffffff802d933c>] sysfs_create_group+0xa2/0x106
> > >  [<ffffffff8069fbc2>] adm1026_detect+0x4b3/0x522
> > >  [<ffffffff8069f70f>] adm1026_detect+0x0/0x522
> > >  [<ffffffff80698bff>] i2c_probe_address+0xb9/0xfc
> > >  [<ffffffff806997db>] i2c_probe+0x162/0x175
> > >  [<ffffffff8069f70f>] adm1026_detect+0x0/0x522
> > >  [<ffffffff8069910f>] i2c_register_driver+0x9a/0xea
> > >  [<ffffffff80c276d2>] kernel_init+0x15d/0x2c9
> > >  [<ffffffff8021fc68>] child_rip+0xa/0x12
> > >  [<ffffffff80c27575>] kernel_init+0x0/0x2c9
> > >  [<ffffffff8021fc5e>] child_rip+0x0/0x12
> > >
> > >
> > > Code: c0 84 c0 74 0c 41 58 48 89 df 5b 5d e9 2a 07 00 00 5e 5b 5d c3
> > > 41 55 49 89 fd 41 54 41 bc f4 ff ff ff 55 53 48 89 f3 48 83 ec 28 <8b>
> > > 76 10 48 8b 3b 66 81 e6 ff 0f 66 81 ce 00 80 0f b7 f6 e8 fd
> > > RIP  [<ffffffff802d79ad>] sysfs_add_file+0x16/0x81
> > >  RSP <ffff81040503dd50>
> > > ---[ end trace b23a825db37d3043 ]---
> >
> > Perhaps the adm1026 driver is not calling sysfs_create_group properly?
> >
> > Jean, any ideas?
>
> Yeah, I am an idiot. In 5b34dbcd88251508d02e48ad9b0f9b8232a13ee0 I
> introduced two new sysfs file groups but forgot to NULL-terminate them.
> Sorry about that, here's the fix:
>
> * * * * *
>
> The missing NULL at the end of two sysfs file groups causes a kernel
> crash when calling sysfs_create_group().
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/hwmon/adm1026.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-2.6.25-rc0.orig/drivers/hwmon/adm1026.c       2008-02-10 11:21:54.000000000 +0100
> +++ linux-2.6.25-rc0/drivers/hwmon/adm1026.c    2008-02-10 18:51:00.000000000 +0100
> @@ -1624,6 +1624,7 @@ static struct attribute *adm1026_attribu
>         &dev_attr_temp3_crit_enable.attr,
>         &dev_attr_temp3_auto_point1_pwm.attr,
>         &dev_attr_temp3_auto_point2_pwm.attr,
> +       NULL
>  };
>
>  static const struct attribute_group adm1026_group_temp3 = {
> @@ -1639,6 +1640,7 @@ static struct attribute *adm1026_attribu
>         &sensor_dev_attr_in9_max.dev_attr.attr,
>         &sensor_dev_attr_in9_min.dev_attr.attr,
>         &sensor_dev_attr_in9_alarm.dev_attr.attr,
> +       NULL
>  };
>
>  static const struct attribute_group adm1026_group_in8_9 = {
>
> * * * * *

it works. Thanks

>
> Yinghai, the bug crept in because I do not have an ADM1026 chip to test
> my changes. Could you please send a dump of your chip to me, so that I
> can emulate it? This would avoid similar problems in the future.
>
> First you have to find out at which address the ADM1026 chip lives. The
> first line of "sensors" should tell, otherwise you can run "i2cdetect
> 1". The ADM1026 can live at 0x2c, 0x2d or 0x2e. Once you know the
> address, run the following command to get the dump:
>
> rmmod adm1026
> i2cdump 1 0x2d b

LBSuse:/x/kernel.org # ./i2cdetect 1
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-1.
I will probe address range 0x03-0x77.
Continue? [Y/n] y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- 08 -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- 18 19 -- -- 1c 1d -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- UU UU -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: 40 41 -- -- -- -- -- -- 48 49 4a -- -- -- -- --
50: UU UU UU UU UU UU -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
LBSuse:/x/kernel.org # ./i2cdump 1 0x2c b
Error: Could not set address to 0x2c: Device or resource busy
LBSuse:/x/kernel.org # ./i2cdump 1 0x2d b
Error: Could not set address to 0x2d: Device or resource busy
