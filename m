Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbXJELhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbXJELhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXJELgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:36:55 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:55294 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbXJELgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:36:54 -0400
Message-ID: <470621A9.10004@gmail.com>
Date: Fri, 05 Oct 2007 14:36:09 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: Ben Gamari <ben@mw0.ath.cx>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-rc9 regression] commit 4f01a757 broke HAL input support
References: <1191198186.13785.21.camel@mercury>	 <1191477703.6408.20.camel@mercury> <200710042311.27864.arvidjaar@mail.ru>	 <200710042240.07039.dmitry.torokhov@gmail.com> <1191557863.6579.0.camel@mercury>
In-Reply-To: <1191557863.6579.0.camel@mercury>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gamari wrote:
> On Thu, 2007-10-04 at 22:40 -0400, Dmitry Torokhov wrote:
>> 4f01a757e75f2a3cab2bab89c4176498963946b9.
> 
> The change that Dmitry proposed would still require
> CONFIG_SYSFS_DEPRECATED, right?

What proposed change?
The changeset you quote is already applied.

Andrey Borzenkov wrote:
>> Actually this specific problem was introduced by 
>> 4f01a757e75f2a3cab2bab89c4176498963946b9. This commit seems to have 
>> completely disassociated eventX from corresponding inputY
>> 
>> To summarize.
>> 
>> 1. Any kernel with SYSFS_DEPRECATED unset
>> 
>> events are sent for /devices/...
>> /devices/.../eventX is direct child of /devices/.../inputY
>> HAL checks for parent of eventX, finds inputY and is happy
>> 
>> 2. SYSFS_DEPRECATED=y, pre-2.6.23 kernel
>> 
>> events are sent for /class/...
>> /class/.../eventX is direct child of /class/.../inputY
>> HAL checks for parent of eventX, finds inputY and works
>> 
>> 3. SYSFS_DEPRECATED=y, 2.6.23 before commit 
>> 4f01a757e75f2a3cab2bab89c4176498963946b9. 
>> 
>> events are sent for /class/...
>> /class/.../eventX is *not* child of /class/.../inputY
>> /class/.../eventX/device points to .../inputY
>> HAL checks for .../device link, finds inputY and works
>> 
>> 4. SYSFS_DEPRECATED=y, 2.6.23 after commit 
>> 4f01a757e75f2a3cab2bab89c4176498963946b9. 
>> 
>> /class/.../eventX is *not* child of /class/.../inputY
>> /class/.../eventX/device points to some physical device
>> HAL finds inputY neither as ../inputY nor as device link and breaks
>> 
>> But what is worse, now the only way to find which inputY corresponds to which 
>> eventX is to scan the whole /class/input, check for device link and compare. 

>> I am afraid that we have to bite the bullet and just accept that 2.6.23 breaks 
>> user space this way or that. Frankly fixing path_id seems to be the least 
>> evil.

I'd hate to see such breakage. IMO the sysfs structure of input devices 
should be made compatible with both HAL and udev, with both 
CONFIG_SYSFS_DEPRECATED and without it, as in 2.6.22 and before.

>> Is it possible to fall back to /class/input/inputX/eventY if SYSFS_DEPRECATED 
>> is set?

Hopefully.

-- 
Anssi Hannula
