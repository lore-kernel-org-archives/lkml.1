Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXGXNHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXGXNHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXGXNHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:07:23 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:18726 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbXGXNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:07:23 -0400
Date: Tue, 24 Jul 2007 09:00:17 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: Adrian Bunk <bunk@stusta.de>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/hwmon/lm93.c: array overruns
Message-ID: <20070724130017.GA5101@jupiter.solarsys.private>
References: <20070723005453.GS26212@stusta.de> <200707230936.58135.hjk@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707230936.58135.hjk@linutronix.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Hans-Jürgen Koch <hjk@linutronix.de> [2007-07-23 09:36:57 +0200]:
> Am Montag 23 Juli 2007 02:54 schrieb Adrian Bunk:
> > The Coverity checker spotted the following array overruns
> > in drivers/hwmon/lm93.c:
> > 
> > <--  snip  -->
> > 
> > ...
> > struct lm93_data {
> > ...
> >         struct {
> >                 u8 min;
> >                 u8 max;
> >         } temp_lim[3];
> > ...
> > };
> > ...
> > static void lm93_update_client_common(struct lm93_data *data,
> >                                       struct i2c_client *client)
> > {
> > ...
> >         for (i = 0; i < 4; i++) {
> >                 data->temp_lim[i].min =
> >                         lm93_read_byte(client, LM93_REG_TEMP_MIN(i));
> >                 data->temp_lim[i].max =
> >                         lm93_read_byte(client, LM93_REG_TEMP_MAX(i));
> >         }
> > ...
> > 
> > <--  snip  -->
> 
> This patch should fix it. Thanks a lot, Adrian!
> 
> ----
> This fixes an array overflow bug. We have 4 pairs of min/max temperature 
> limits, not 3.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 
> --
> Index: linux-2.6.23-rc/drivers/hwmon/lm93.c
> ===================================================================
> --- linux-2.6.23-rc.orig/drivers/hwmon/lm93.c	2007-07-23 09:22:56.000000000 +0200
> +++ linux-2.6.23-rc/drivers/hwmon/lm93.c	2007-07-23 09:29:37.000000000 +0200
> @@ -234,7 +234,7 @@
>  	struct {
>  		u8 min;
>  		u8 max;
> -	} temp_lim[3];
> +	} temp_lim[4];
>  
>  	/* vin1 - vin16: low and high limits */
>  	struct {
> 
> 

Applied to testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

