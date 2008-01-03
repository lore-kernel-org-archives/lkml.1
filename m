Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYACHA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYACHA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYACHAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:00:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:15957 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYACHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:00:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gxM9WpTlYcJD1xkYre0EJ7MaJf42luLCB0duOSNwkiddxZO5RtPqWj9zevr1sXnkDMm/3kf5FxSi2BCGs7RczBkhaOvOTmmCZFLb4INo5Qmp6S9LuSc1bipIX4iy4b9r0Is5+Fkw13yiyUDCCV5Un2vlawdod/2edxYzwfxvlGU=
Date: Thu, 3 Jan 2008 08:06:09 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org,
       david-b@pacbell.net, davem@davemloft.net, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net,
       James.Bottomley@HansenPartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org,
       i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080103070609.GA1677@ff.dom.local>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 01:50:20PM +0800, Dave Young wrote:
> Convert semaphore to mutex in struct class.
...
> One lockdep warning detected as following, thus use mutex_lock_nested with SINGLE_DEPTH_NESTING in class_device_add
> 
> Jan  3 10:45:15 darkstar kernel: =============================================
> Jan  3 10:45:15 darkstar kernel: [ INFO: possible recursive locking detected ]
> Jan  3 10:45:15 darkstar kernel: 2.6.24-rc6-mm1-mutex #1
> Jan  3 10:45:15 darkstar kernel: ---------------------------------------------
...
> If there's anything missed please help to point out, thanks.

Dave, IMHO it's not 'the right' way to do it: from this and earlier
discussions it seems there could be many more warnings like this one;
lockdep simply always turns itself off after first one. So, merging
your patches like this would effectively turn off lockdep for all
other places as well, maybe for a long time.

I'd suggest to try first to do it with some wrappers around mutexes,
which simply omit lockdep verification, and later try to replace them
one by one, after checking and testing there are no such warnings
anymore (which would often need some additional annotations about
nesting and probably some changes in lockdep too).

Thanks,
Jarek P.
