Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXEYWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXEYWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXEYWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:47:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:58046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXEYWrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:47:41 -0400
Subject: Re: [patch 4/7] ps3: Storage Driver Probing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705251818.03964.arnd@arndb.de>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.474400000@sonycom.com>  <200705251818.03964.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 26 May 2007 08:47:09 +1000
Message-Id: <1180133229.19517.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 18:18 +0200, Arnd Bergmann wrote:
> > +static u64 ps3stor_wait_for_completion(u64 devid, u64 tag,
> > +                                    unsigned int timeout)
> > +{
> > +     unsigned int retries = 0;
> > +     u64 res = -1, status;
> > +
> > +     for (retries = 0; retries < timeout; retries++) {
> > +             res =
> lv1_storage_check_async_status(NOTIFICATION_DEVID, tag,
> > +                                                  &status);
> > +             if (!res)
> > +                     break;
> > +             set_current_state(TASK_INTERRUPTIBLE);
> > +             schedule_timeout(1);
> > +     }
> 
> Any reason not to use msleep(1) instead of the schedule_timeout? 

Both look equally ugly though... do you really have to poll ?

Ben.


