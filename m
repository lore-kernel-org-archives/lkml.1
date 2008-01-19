Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYASTsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYASTsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYASTsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:48:37 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:30001 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYASTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:48:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H7GwgF/OrVTPgK3y8VICr63lcJqp80s7xxAG6eYN8Xc3FsvuJpwyjLR5O8Mh+lOc3da9havOnZhLVvPmzj18FnFpXrtQNMNJSM1X/jJwNWgNoBS6TDSOaahUZ/G6uctddFO57MGdCBD/StEsCnmRTJclKl9Ui7SWZXLItX4PncQ=
Message-ID: <bc64b4640801191148m39ae5cd6ra190ac8e9c40fba7@mail.gmail.com>
Date: Sat, 19 Jan 2008 22:48:32 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Dmitry Baryshkov" <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, liam.girdwood@wolfsonmicro.com
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
In-Reply-To: <20080119170030.GA469@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118162627.GA28974@rakim.wolfsonmicro.main>
	 <1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20080118120148.ZZRA012@mailhub.coreip.homeip.net>
	 <fmqq50$te0$1@ger.gmane.org> <20080119170030.GA469@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/1/19, Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Jan 18, 2008 at 06:11:45PM +0000, Dmitry Baryshkov wrote:
> > Dmitry Torokhov wrote:
>
> > > I will need some more time to review and understand the need for the new
> > > bus in the driver.
>
> > Most likely this can be converted to platform_bus. Maybe this can also get
>
> Could you expand on how you see that being implemented, please?  It
> doesn't feel entirely comfortable to me - providing a bus for the chip
> seems more direct and the platform bus not what I'd think of using for
> something hanging off another bus - but I think I'm just not visualising
> what you're thinking of properly.

Well... It's a common suggestion not to duplicate code. The wm97xx bus
looks mostly like platform. The only difference is the name. To help
visualisation, devices can have parents. Just set (in pseudocode)
wm97xx-touchscreen->parent to wm97xx, do the same for wm97xx-battery
and so on. Thus all devices would be on the platform device but with
proper parent <-> child notation.

> > help from soon-to-be posted MFD (multi function devices) helpers.
>
> The multi-function device support does feel like it could be a good fit.
> I'd seen it discussed sometime last year but don't recall seeing
> anything for quite a while.  Like Ben said, any pointers to current work
> would be appreciated.

You can find the current work at
git://git.mnementh.co.uk/linux-2.6-im.git#tmio_dev_try3. Look for
"Core MFD support" changeset.

>
> It's probably worth mentioning that in addition to what is in the
> current patch series these chips all also provide an audio codec which
> requires a reasonably substantial driver for full support.
>

This would only touch child devices organisation.

-- 
With best wishes
Dmitry
