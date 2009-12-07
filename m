Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZLGAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZLGAz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbZLGAzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:55:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37979 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbZLGAzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=I6uvZ2PaPM6y7ndiKCLZkEpzoJWk30r+wPwtscZ2JQAK5po1400Luc5yEAz7LlXANO
         OVLNqkqbH97j9IzY4INpPBZF1QGx8b6f8hEkqMOLOMud+C/gd4lfrmbKT9RxD8eOPjWg
         VOs3PO9WPPM+AOfqZblK2wgdoZa61AAwLFjqc=
Subject: Re: [PATCH v8 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091206084717.GD2766@ucw.cz>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <d8789fa7e97d8a170c4e2516d7ef2d2fbbe42cc6.1260082252.git.wuzhangjin@gmail.com>
	 <20091206084717.GD2766@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 07 Dec 2009 08:54:58 +0800
Message-ID: <1260147298.3126.2.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 09:47 +0100, Pavel Machek wrote: 
> Hi!
> 
> > +static int get_battery_current(void)
> > +{
> > +	s16 value;
> > +
> > +	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
> > +		(ec_read(REG_BAT_CURRENT_LOW));
> > +
> > +	if (value < 0)
> > +		value = ~value + 1;
> > +
> > +	return value;
> > +}
> 
> What is going on here? I thought the value is already in two's
> complement... Is the above equivalent of
> 
> 	      if (value < 0)
> 	      	 value = -value; 
> 
> ? If so, why? If not, can you add a comment?

Right, then, will use this instead:

static int get_battery_current(void)
{ 
	s16 value;

	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
		(ec_read(REG_BAT_CURRENT_LOW));

	return abs(value);
}

Thanks & Best Regards,
	Wu Zhangjin


