Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXDORyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXDORyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXDORyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:54:03 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:29547 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753250AbXDORyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:54:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ym9Q0uItmGgQa6WAyVb3IYAuxtyENLWaqH6FNXYM6JHbmLSR2lbqgirM6LgyJPZQ4C7HOaAThqyG+tSMWIC71oOTcYu487vk6MYHveFCJ5wIwNbtyvrsCOQn8q0IVqRsvvaS7mrEtyCUEs+1msOQzqkMgR3Z6jslEj2ov6R7IOQ=  ;
X-YMail-OSG: s3oiu_8VM1nmahzxtMrFPpT5gX4j97uhn_LXF05Ipx7ShljP
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 10:53:56 -0700
User-Agent: KMail/1.7.1
Cc: linux-pm@lists.linux-foundation.org,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704150814.01747.david-b@pacbell.net> <200704151837.40756.rjw@sisk.pl>
In-Reply-To: <200704151837.40756.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151053.56939.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 9:37 am, Rafael J. Wysocki wrote:
> 
> Which makes me think the following patch might help:
> 
>  drivers/input/serio/i8042.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc6/drivers/input/serio/i8042.c
> ===================================================================
> --- linux-2.6.21-rc6.orig/drivers/input/serio/i8042.c	2007-04-07 12:15:19.000000000 +0200
> +++ linux-2.6.21-rc6/drivers/input/serio/i8042.c	2007-04-15 18:30:01.000000000 +0200
> @@ -846,7 +846,8 @@ static long i8042_panic_blink(long count
>  static int i8042_suspend(struct platform_device *dev, pm_message_t state)
>  {
>  	if (dev->dev.power.power_state.event != state.event) {
> -		if (state.event == PM_EVENT_SUSPEND)
> +		if (state.event == PM_EVENT_SUSPEND
> +		    || state.event == PM_EVENT_PRETHAW)

Yeah, lack of PRETHAW support could be an issue.  As you may recall,
it was added because otherwise statically linked USB host controllers
came up under the mistaken belief that they were getting a real resume
event rather than a restart-after-power-off ... and there needed to be
a way to force a hard reset.  Seems like a similar issue here.

- Dave


>  			i8042_controller_reset();
>  
>  		dev->dev.power.power_state = state;
> 
