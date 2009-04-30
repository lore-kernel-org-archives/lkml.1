Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbZD3VwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbZD3VwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760231AbZD3Vvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:51:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377AbZD3Vvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:51:48 -0400
Date: Thu, 30 Apr 2009 14:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org,
       linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-core: Fix potential mutex_unlock without mutex_lock
 in dvb_dvr_read
Message-Id: <20090430144840.6605e564.akpm@linux-foundation.org>
In-Reply-To: <49FA1B2E.8030402@simon.arlott.org.uk>
References: <49F0A61D.1010002@simon.arlott.org.uk>
	<20090430131818.d8aded42.akpm@linux-foundation.org>
	<49FA1B2E.8030402@simon.arlott.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 22:42:06 +0100
Simon Arlott <simon@fire.lp0.eu> wrote:

> >> diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
> >> index c35fbb8..d6d098a 100644
> >> --- a/drivers/media/dvb/dvb-core/dmxdev.c
> >> +++ b/drivers/media/dvb/dvb-core/dmxdev.c
> >> @@ -247,7 +247,7 @@ static ssize_t dvb_dvr_read(struct file *file, char __user *buf, size_t count,
> >>  	int ret;
> >>  
> >>  	if (dmxdev->exit) {
> >> -		mutex_unlock(&dmxdev->mutex);
> >> +		//mutex_unlock(&dmxdev->mutex);
> >>  		return -ENODEV;
> >>  	}
> > 
> > Is there any value in retaining all the commented-out lock operations,
> > or can we zap 'em?
> 
> I'm assuming they should really be there - it's just not practical
> because the call to dvb_dmxdev_buffer_read is likely to block waiting
> for data.

well..  such infomation is much better communicated via a nice comment,
rather than mystery-dead-code?

