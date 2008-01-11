Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbYAKTQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbYAKTQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYAKTPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:15:55 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4836 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758791AbYAKTPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:15:54 -0500
Date: Fri, 11 Jan 2008 20:15:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 0/5] Version 17, series to add device tree naming
 to i2c
Message-ID: <20080111201550.12abb02c@hyperion.delvare>
In-Reply-To: <9e4733910801110752k57f1fd7crd5f143900fc64f0b@mail.gmail.com>
References: <20071220044136.20091.70984.stgit@terra.home>
	<20080111095638.775670ed@hyperion.delvare>
	<9e4733910801110752k57f1fd7crd5f143900fc64f0b@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 10:52:56 -0500, Jon Smirl wrote:
> On 1/11/08, Jean Delvare wrote:
> > Now that I have read all the previous versions of this patch series
> > and, more importantly, all objections that were raised on the way, I
> > can start reviewing the latest iteration of your patches. I'll also do
> > some testing, although I have no powerpc stuff here, but at least I
> > want to make sure that there are no regressions introduced by your
> > patches on x86.
> 
> 
> Various people were worried about x86. Around version 15 I altered the
> patches so that they only impacted PowerPC. If they impact x86 in
> current form that is a bug.
> 
> When x86 is ready for it I do think dynamic module loading should be
> implemented there also.

I agree, and I am doing some testing on x86 to make sure that your
patch will work fine there as well once we decide to go that way.

Your patch set really contains two different parts which should be
clearly identified and discussed separately. Firstly, it lets i2c
drivers export module aliases so that the rest of the world knows which
devices they support. This part I think everybody agrees is needed, so
that platform code no longer needs to specify the driver name for every
I2C device.

Secondly, it promotes OF device names as acceptable aliases. This I
don't think I agree with. While I see some value in moving the OF name
-> Linux name translation to the drivers themselves (even though I
don't see this as a mandatory move either), this doesn't imply that OF
names should be used as aliases. I don't like the idea that different
architectures will name the same device differently in a visible way.
This could easily break user-space code that makes assumptions on the
device names (libsensors comes to mind.) So, I think that this part
will need some more discussion.

-- 
Jean Delvare
