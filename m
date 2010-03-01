Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab0CALKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:10:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44771 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab0CALKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:10:09 -0500
Date: Mon, 1 Mar 2010 12:10:07 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [rtc-linux] [PATCH 6/6] rtc/mc13783: implement alarm
Message-ID: <20100301111007.GD16049@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de> <1267440825-14694-6-git-send-email-u.kleine-koenig@pengutronix.de> <20100301115625.5d048580@linux.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100301115625.5d048580@linux.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 11:56:25AM +0100, Alessandro Zummo wrote:
> On Mon,  1 Mar 2010 11:53:45 +0100
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
> > for now this just ignores the possible race to trigger an alarm when
> > setting the time.  Should I resolve that, if so, what is the prefered
> > way to do that?
> 
>  I saw you email on the topic but I haven't had
>  the time to answer appropriately. 
> 
>  I'd suggest to disable the alarm irq while setting
>  the time.
I have two possibilities, I'm not sure if you mean the first or just any
of the two:

  1)
	pending = is_alarm_pending
	mask_alarm_irq
	set time and date
	if (!pending)
		ack_alarm_irq
	unmask_alarm_irq

  2)
	alarmtime = read_alaram
	program_alarm(invalid)
	set time and date
	program_alarm(alarmtime)

I'd prefer 2), is that OK for you, too?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
