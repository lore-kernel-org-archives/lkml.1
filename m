Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbYFDW6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbYFDW6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYFDW6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:58:00 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:9057 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYFDW57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:57:59 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <48471DF1.70505@tremplin-utc.net>
Date: Thu, 05 Jun 2008 00:57:53 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection  System 3D
 ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost>	<4846EBF5.2030406@tremplin-utc.net> <20080604225830.1dff64fc@hyperion.delvare>
In-Reply-To: <20080604225830.1dff64fc@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04-06-08 22:58, Jean Delvare wrote/a écrit:
> Hi Eric,
> 
> On Wed, 04 Jun 2008 21:24:37 +0200, Éric Piel wrote:
>> We haven't received any review for this driver since last week's post by
>> Yan :-( That's why I'm adding explicitly as receivers of this email all
>> the people who have reviewed the first two previous takes. Apologies for
>> the possible multiple receptions.
>>
>> It would be _really really kind_ if some of you could take some time and
>> comment (or simply ACK ;-) ) this code. It adds support for hardware
>> which can be found in mostly every HP Compaq laptop less than three
>> years old. It's quite worthy.
>>
>> Mark, as maintainer of the hwmon tree, would accept this driver? Let us
>> know if there are things we need to change.
> 
> If you didn't receive any answer, my guess is that it's because you're
> trying to add this driver to the wrong tree. Why would this driver go
> in drivers/hwmon and be reviewed by hwmon folks, when it doesn't expose
> a single hwmon attribute to user-space?
> 
> I guess you thought putting the driver there would be fine because
> that's where the hdaps and ams drivers are, but IMHO the hdaps and ams
> drivers should never have been placed in drivers/hwmon. These devices
> really aren't hardware monitoring chips is the traditional sense of the
> term. They are different chips, serving different purposes and
> deserving a totally different interface. They'd better live in a
> different subsystem and be maintainer by a different crew with interest
> in these devices and hardware to test the drivers.
> 
> This discussion thread might sched some light on a possible approach:
> http://marc.info/?l=lm-sensors&m=121127824726050&w=2
> 
> So my advice is that you don't wait for a review from the hwmon people,
> because apparently we don't have much interest in this type of device,
> so you'll be waiting forever. You're much better adding the mdps driver
> to drivers/misc through Andrew Morton, at least until someone takes
> care of creating a subsystem for this type of devices and move all
> existing drivers there.
Hi Jean,
I understand your argumentation. Indeed, this driver has nothing
specially related to hwmon, excepted that all the other accelerometers
so far have been put in hwmon. I've got nothing against redoing the
patch to move the code to drivers/misc. Andrew, would you accept it?

> Would someone object to moving the hdaps and ams (and possibly
> applesmc) drivers to drivers/misc?
Yeah, applesmc seems a bit less obvious because it also exposes really
some hardware sensors. Any idea how to handle this? Just leave it in
hwmon for now?

So, the rational about moving all these drivers to drivers/misc/ would
be that it shows they have no relation with hwmon, and they are
maintained separately. This would be a temporary place until the
"accelerometer" subsystem exists by it own, right?
If everyone is happy with this idea, I can submit a separate patch to
move them.

See you,
Eric
