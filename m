Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZLDQaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZLDQaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932150AbZLDQaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:30:09 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:39183 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbZLDQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:30:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cUTVwVLcr5IiRqDEQPePYG+aRXe0tULyr4Uf0alfMDLsjsr0+gAALF/MkbOHSZ+q4Z
         fZNyrr/JFccdCyNbuD3X4uFpnq4RiQ7qVa9TsqTvuGZV6cJxZTtAZmRZJJNR1Un/3wcz
         FTNTKprxWTgTnpFuZgVpPrLOjFL1Wg2IXPcZY=
Subject: Re: [PATCH v7 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org
In-Reply-To: <20091204080813.GB1540@ucw.cz>
References: <cover.1259932036.git.wuzhangjin@gmail.com>
	 <102732263f647e47216c1f2cb121c30226cc995e.1259932036.git.wuzhangjin@gmail.com>
	 <20091204080813.GB1540@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sat, 05 Dec 2009 00:29:45 +0800
Message-ID: <1259944185.9554.8.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 09:08 +0100, Pavel Machek wrote:
> Hi!
> 
> > +static int get_cpu_temp(void)
> > +{
> > +	int value;
> > +
> > +	value = ec_read(REG_TEMPERATURE_VALUE);
> > +
> > +	if (value & (1 << 7))
> > +		value = (value & 0x7f) - 128;
> > +	else
> > +		value = value & 0xff;
> 
> wtf?
> 
> Maybe value should be 's8'?
> 
> > +static int get_battery_current(void)
> > +{
> > +	int value;
> > +
> > +	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
> > +		(ec_read(REG_BAT_CURRENT_LOW));
> > +
> > +	if (value & 0x8000)
> > +		value = 0xffff - value;
> 
> Another version of  pair-complement conversion; this one is broken --
> off by 1.
> 
> > +static int parse_arg(const char *buf, unsigned long count, int *val)
> > +{
> > +	if (!count)
> > +		return 0;
> > +	if (sscanf(buf, "%i", val) != 1)
> > +		return -EINVAL;
> > +	return count;
> > +}
> 
> We have strict_strtoul for a reason...
> 

Done, thanks!

Regards,
	Wu Zhangjin

