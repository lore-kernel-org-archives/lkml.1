Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZLGH12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZLGH12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758269AbZLGH12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:27:28 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52602 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZLGH11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Ct70tVd3UzdW56B5DOxNjcdSIVOB0HQEjBUNC/JV5ufYgR9CZiVIWT/nWzkDHS6ztn
         OdhyFrMZ/NGZf97c1HRe84Cl1xYi8FGQrwzRFFr1Zt1lxctdPxcrLEvz80tkxzlFdqiM
         WgGGg40MKHaKDriw+tbm8A29XVVRybm6hZ4Bo=
Subject: Re: [PATCH v8 8/8] Loongson: YeeLoong: add input/hotkey driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20091207064857.GG21451@core.coreip.homeip.net>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <b164d5bb79963a57621d024c22e5664de0ff8662.1260082252.git.wuzhangjin@gmail.com>
	 <20091207064857.GG21451@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 07 Dec 2009 15:26:47 +0800
Message-ID: <1260170807.9092.9.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 22:48 -0800, Dmitry Torokhov wrote:
> Hi Wu,
> 
> On Sun, Dec 06, 2009 at 03:01:48PM +0800, Wu Zhangjin wrote:
> > +
> > +#define EC_VER_LEN 64
> > +
> > +static int black_screen_handler(int status)
> > +{
> > +	char *p, ec_ver[EC_VER_LEN];
> > +
> > +	p = strstr(loongson_cmdline, "EC_VER=");
> > +	if (!p)
> > +		memset(ec_ver, 0, EC_VER_LEN);
> > +	else {
> > +		strncpy(ec_ver, p, EC_VER_LEN);
> > +		p = strstr(ec_ver, " ");
> > +		if (p)
> > +			*p = '\0';
> > +	}
> > +
> 
> Hmm, why do you copy and parse command lineinstead of using module
> param and also doing it just once?
> 

The kernel command line (EC_VER=blabla) is passed by bootloader(PMON)
automatically, so, I think it's better to use it.

Using an extra module param is good, but may make the users confused and
will also add extra jobs to the distribution developers ;) in the
future, the information of the EC and the other information of the
devices will be passed to kernel from BIOS via something like
FDT(Flattened Device Tree, used on PowerPC machines) as Ralf introduced,
so, the above method is a temp solution.

Thanks & Regards,
	Wu Zhangjin

> > +	/* Seems EC(>=PQ1D26) does this job for us, we can not do it again,
> > +	 * otherwise, the brightness will not resume to the normal level! */
> > +	if (strncasecmp(ec_ver, "EC_VER=PQ1D26", 64) < 0)
> > +		yeeloong_lcd_vo_set(status);
> > +
> > +	return status;
> > +}
> 
> Thanks.
> 


