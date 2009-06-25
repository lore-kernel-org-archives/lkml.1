Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbZFYPGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbZFYPGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZFYPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:06:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39745 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZFYPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:06:16 -0400
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
	driver
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Alek Du <alek.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
In-Reply-To: <1245941565.20530.134.camel@jani-desktop>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	 <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	 <20090625210642.432e08a5@dxy.sh.intel.com>
	 <1245936693.20530.107.camel@jani-desktop>
	 <20090625220826.1fa7413e@dxy.sh.intel.com>
	 <1245941565.20530.134.camel@jani-desktop>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 18:05:55 +0300
Message-Id: <1245942355.20530.141.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 15:06:01.0990 (UTC) FILETIME=[7436E260:01C9F5A6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 16:52 +0200, Jani Nikula wrote:
> On Thu, 2009-06-25 at 16:08 +0200, ext Alek Du wrote:
> > If you schedule the timer when you decide it "stabilized", the final gpio_get_value()
> > could still return 0 in the timer handler, if the key released at that time. So your previous
> > "stabilized" state is useless.
> 
> True, gpio_keys_report_event should also compare the value to the
> previous state and bail out if it's unchanged. Something along the lines
> of:
> 
> @@ -46,6 +46,10 @@ static void gpio_keys_report_event(struct work_struct *work)
>  	unsigned int type = button->type ?: EV_KEY;
>  	int state = (gpio_get_value(button->gpio) ? 1 : 0) ^ button->active_low;
>  
> +	if (state == bdata->state)
> +		return;
> +	bdata->state = state; 

Actually scrap that, the input layer already ignores events with no
state changes, right?

> Debouncing should also completely ignore a single spike shorter than
> debounce_interval. Admittedly gpio-keys was flawed, but please consider
> a change like above which should fix that.

Same here, gpio-keys did ignore spikes shorter than debounce_interval.


BR,
Jani.


