Return-Path: <linux-kernel-owner+w=401wt.eu-S934822AbZLHGwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822AbZLHGwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbZLHGwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:52:47 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:49001 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZLHGwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=EfxRhkYH9GtE2DXw82g+dGfkHQqt2wrjk60EmytRA91YE1JJQ9QFh3Olil9j8UF6BI
         bkjDBDna0OZZzSJNX8r+gRXc0cEoz/ErFQruwJCs/j0FXajC3YUlgiK7cMoiM1GVOCqx
         5Cfbw1ixlgimuaW7YzH/l4YsY5eBvgyx4hBV0=
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
Date: Tue, 08 Dec 2009 14:52:11 +0800
Message-ID: <1260255131.3315.25.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dmitry Torokhov

I plan to send another revision of this patchset, Can I get your
Acked-by: for this patch?

Thanks!
	Wu Zhangjin

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


