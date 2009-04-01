Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZDAI3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZDAI3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZDAI2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:28:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33666 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760703AbZDAI2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:28:35 -0400
Date: Wed, 1 Apr 2009 10:28:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: sakari.ailus@maxwell.research.nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trilok Soni <soni.trilok@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 29/58] move omap24xxcam's probe function to
	.devinit.text
Message-ID: <20090401082830.GA27668@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-29-git-send-email-u.kleine-koenig@pengutronix.de> <49D31A5F.90108@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D31A5F.90108@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Sakari,

On Wed, Apr 01, 2009 at 10:40:15AM +0300, Sakari Ailus wrote:
> ext Uwe Kleine-König wrote:
>> A pointer to omap24xxcam_probe is passed to the core via
>> platform_driver_register and so the function must not disappear when the
>> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
>> unbinding and binding a device to the driver via sysfs will result in an
>> oops as does a device being registered late.
>>
>> An alternative to this patch is using platform_driver_probe instead of
>> platform_driver_register plus removing the pointer to the probe function
>> from the struct platform_driver.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Cc: Sakari Ailus <sakari.ailus@nokia.com>
>> Cc: Trilok Soni <soni.trilok@gmail.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  drivers/media/video/omap24xxcam.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Does your S-o-b means you care for inclusion in mainline?[1]  Or should
I record that as an Acked-by?

Best regards
Uwe

[1] Quoting Documentation/SubmittingPatches:
	"The Signed-off-by: tag indicates that the signer was involved
	in the development of the patch, or that he/she was in the
	patch's delivery path.

	If a person was not directly involved in the preparation or
	handling of a patch but wishes to signify and record their
	approval of it then they can arrange to have an Acked-by: line
	added to the patch's changelog."
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
