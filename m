Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYC0MA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYC0MA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYC0MAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:00:17 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:26923 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYC0MAQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:00:16 -0400
X-Greylist: delayed 66190 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 08:00:15 EDT
Date: Thu, 27 Mar 2008 12:00:11 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Dave Airlie <airlied@gmail.com>,
       I2C <i2c@lm-sensors.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080327120011.GA5296@deepthought>
References: <20080325200714.GA25487@deepthought> <20080326161934.7eae544f@hyperion.delvare> <20080326173701.GA16882@deepthought> <20080326201031.7c2cefb2@hyperion.delvare> <Pine.LNX.4.58.0803261832200.16692@shell4.speakeasy.net> <20080327092617.2ab088ff@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080327092617.2ab088ff@hyperion.delvare>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 09:26:17AM +0100, Jean Delvare wrote:
> On Wed, 26 Mar 2008 18:35:10 -0700 (PDT), Trent Piepho wrote:
> > On Wed, 26 Mar 2008, Jean Delvare wrote:
> > > Totally unrelated, but FYI: the chip at 0x50 is an EDID EEPROM in your
> > > display (which the radeonfb driver can use to switch to the correct
> > > resolution / refresh rate.)
> > [...]
> > > any of these chips. So, the mysterious effect of unloading the
> > > i2c-viapro driver can't be explained by an i2c chip driver detaching
> > > from its device. So, again, I really can't see how i2c can be involved
> > > in your problem.
> > 
> > Maybe the radeonfb driver is trying to talk to EDID EEPROMs on all I2C
> > adapters it finds?  When it tries to using the i2c-viapro adapter, it
> > hangs.
> 
> No, the radeonfb driver only probes for EEPROMs on (at most) its 4 own
> I2C buses. It doesn't even know about the other I2C buses on the system.
> 
> Note that I am using radeonfb and i2c-viapro myself, so if there was a
> conflict between both drivers, I think would know by now. I've not
> experienced the problem reported by Ken. But I don't use gdm.
> 
> Note that I am using the X.org radeon driver. Ken did not tell which X
> driver he was using, maybe it matters.
> 
 I was going to delay replying, because I had nothing to report -
tried changing the interesting differences in the 64-bit .config
where it looked as if I had strayed from what is in the current
defconfig, no change.  Tried removing radeonfb (oh, the horrible
screen size of 80x25!), no change.  I haven't looked in detail at
drivers.

 For Trent: if I use the ('bad') system as normal, log out to gdm,
then log in again it is fine.  That involves the screen going black
and then gdm restarts X, paints the background and puts up a window.
It's only attempts to shut down or restart (reboot) which dismiss the
gdm dialog window but leave the background in place - on 'good'
kernels, the screen goes black and then the console messages appear
as soon as I click the confirm or ok or whatever button.

 I'm on xorg-7.3 on this system with xorg-server-1.4.0.90 and
xf86-video-ati ('ati') - until yesterday evening I was still using
6.7.196, then I upgraded to 6.8.0 but that too changed nothing.

 I'll try -rc7, just in case, then I'll see if I can change the
32-bit config to provoke the problem.  I see debian users have been
hitting a race with gdm, but this isn't debian (it's all compiled
from source) and I do have dbus-1.1.2 and dbus-glib-0.74 installed.

 Thanks for the suggestions.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
