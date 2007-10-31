Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbXJaTLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbXJaTLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXJaTLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:11:30 -0400
Received: from smtpauth12.prod.mesa1.secureserver.net ([64.202.165.35]:51737
	"HELO smtpauth12.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753299AbXJaTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:11:30 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 15:11:30 EDT
Message-ID: <4728D1AB.7060100@cyberdata.net>
Date: Wed, 31 Oct 2007 12:04:11 -0700
From: Cameron Barfield <cbarfield@cyberdata.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Blackfin SPI driver: Move cs_chg_udelay to	cs_deactive
 to fix bug when some SPI LCD driver needs delay after	cs_deactive
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>	 <1193735885-8202-14-git-send-email-bryan.wu@analog.com>	 <200710301319.00071.david-b@pacbell.net> <1193812204.6971.14.camel@roc-laptop>
In-Reply-To: <1193812204.6971.14.camel@roc-laptop>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It may be hardware specific for our board, but my thought is that any device should be
able to take advantage of the cs_chg_udelay regardless of which write function it uses.

As far as I can see, there is no where else to make a clean change to allow devices that
use the "normal" write function the ability to take advantage of cs_chg_udelay.



Bryan Wu wrote:
> On Tue, 2007-10-30 at 13:18 -0700, David Brownell wrote:
>> On Tuesday 30 October 2007, Bryan Wu wrote:
>>> @@ -211,6 +211,10 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
>>>         flag |= (chip->flag << 8);
>>>  
>>>         write_FLAG(drv_data, flag);
>>> +
>>> +       /* Move delay here for consistency */
>>> +       if (chip->cs_chg_udelay)
>>> +               udelay(chip->cs_chg_udelay);
>>>  }
>>>  
>> By the way, if this is something needed very often, that mechanism
>> should be moved into the SPI framework.  It wouldn't be polite if
>> such LCD drivers could only work on Blackfin boards.  :)
> 
> I am not sure whether this LCD needs cs_chg_udelay on other boards.
> It is found by Cameron Barfield. Maybe it is some timing requirement for
> specific hardware.
> 
> -Bryan Wu
> 
> 

- --
NOTICE AND DISCLAIMER:

This e-mail message and any attachments may contain confidential information intended
solely for the specified individual(s).
If you are not the intended recipient, you are prohibited from viewing, disseminating,
copying, disclosing, or relying upon this
message or any attachment in any way.

If you received this e-mail in error, you should (1) immediately notify the sender by
forwarding this e-mail to him, her, or it and
(2) delete the original e-mail message and all attachments without reading or saving any
of them in any manner.

CyberData Corporation does not accept liability for any damage caused by any virus
transmitted through this e-mail or its
attachments.  CyberData Corporation does not accept liability for any errors or omissions
in the contents of this e-mail
message or any of its attachments.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHKNGq49ZuPDUolt0RAqq/AJ4pU67Hopp42saSVhxAbSHXK8CPCgCfTjTx
ky1p5ou7vrNBTR4VB3b9zQc=
=3UiY
-----END PGP SIGNATURE-----
