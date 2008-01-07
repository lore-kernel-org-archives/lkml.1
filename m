Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYAGIHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYAGIHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYAGIHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:07:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:41666 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYAGIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Pk4MwYS6+f9JqSveeC3vYvrzWgoxhhhJamg6QMicnOFMp9vv7rNuSwCKgBnpzu/GZEUShmZbvfVDYhEYMV/tc4wBPPky4YdPahMPZ2Xfr6xBU/gbDO4CTsacD8knb5jHSkTE7HZ2PSZYV1d9OXTzv+tldll0T4onDaFEzIfdFHQ=
Message-ID: <4781DDCA.20605@gmail.com>
Date: Mon, 07 Jan 2008 17:07:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080103131620.GA16307@boogie.lpds.sztaki.hu> <20080104010542.GA2860@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080104010542.GA2860@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> On Thu, Jan 03, 2008 at 02:16:21PM +0100, Gabor Gombas wrote:
>> On Wed, Jan 02, 2008 at 04:16:42PM +0100, Gabor Gombas wrote:
>>
>>> So the patch referenced above does not help. But I've found a very easy
>>> way to trigger the bug:
>>>
>>> - do a "cat /dev/zero > /dev/rfcomm0"
>>> - switch the phone off
>>> - switch the phone on, and the kernel oopses
>> FYI I also remember having oopses with 2.6.22.<something> but I do not
>> have those logs anymore. Also I now booted 2.6.20.7 and it did not oops.
> 
> Could you try the patch (on 2.6.24-rc6) following and check the debug messages? 
> 
> diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
> --- linux/net/bluetooth/rfcomm/tty.c	2008-01-04 08:58:48.000000000 +0800
> +++ linux.new/net/bluetooth/rfcomm/tty.c	2008-01-04 09:01:01.000000000 +0800
> @@ -313,6 +313,7 @@ static void rfcomm_dev_del(struct rfcomm
>  {
>  	BT_DBG("dev %p", dev);
>  
> +	dump_stack();
>  	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
>  	rfcomm_dev_put(dev);
>  }

Tried to reproduce the problem here but I can't persuade my laptop to
talk to my cell. :-( Gabor, can you please report what Dave Young asked?

Thanks.

-- 
tejun
