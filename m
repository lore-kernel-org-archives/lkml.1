Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbXEZI4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbXEZI4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 04:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXEZI4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 04:56:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49986 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753815AbXEZI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 04:56:33 -0400
Date: Sat, 26 May 2007 10:56:32 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/7] ps3: Storage Driver Probing
In-Reply-To: <1180133229.19517.13.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.62.0705261055180.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.474400000@sonycom.com>
 <200705251818.03964.arnd@arndb.de> <1180133229.19517.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007, Benjamin Herrenschmidt wrote:
> On Fri, 2007-05-25 at 18:18 +0200, Arnd Bergmann wrote:
> > > +static u64 ps3stor_wait_for_completion(u64 devid, u64 tag,
> > > +                                    unsigned int timeout)
> > > +{
> > > +     unsigned int retries = 0;
> > > +     u64 res = -1, status;
> > > +
> > > +     for (retries = 0; retries < timeout; retries++) {
> > > +             res =
> > lv1_storage_check_async_status(NOTIFICATION_DEVID, tag,
> > > +                                                  &status);
> > > +             if (!res)
> > > +                     break;
> > > +             set_current_state(TASK_INTERRUPTIBLE);
> > > +             schedule_timeout(1);
> > > +     }
> > 
> > Any reason not to use msleep(1) instead of the schedule_timeout? 
> 
> Both look equally ugly though... do you really have to poll ?

The special notification device (NOTIFICATION_DEVID = -1) is not in the
repository and AFAIK it doesn't have an interrupt attached to it.
Note that this is used during probing only.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
