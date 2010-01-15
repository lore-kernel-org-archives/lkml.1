Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab0AONMd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255Ab0AONMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:12:32 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:59313 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753979Ab0AONMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:12:32 -0500
Date: Fri, 15 Jan 2010 16:12:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>, "cbou@mail.ru" <cbou@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Message-ID: <20100115131229.GA30213@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <175E0F9A9EFCEA46A65F5552BB0572980445D2BE30@bgsmsx502.gar.corp.intel.com>
 <20100111213242.GA3985@oksana.dev.rtsoft.ru>
 <175E0F9A9EFCEA46A65F5552BB0572980445DB31FB@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <175E0F9A9EFCEA46A65F5552BB0572980445DB31FB@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 05:31:55PM +0530, Mahalingam, Nithish wrote:
[...]
> >> +       unsigned int batt_charge_now;           /* in mAS */
> >> +       unsigned int batt_prev_charge_full;     /* in mAS */
> >> +       unsigned int batt_charge_rate;          /* in units per second */
> > 
> > Per include/linux/power_supply.h and
> > Documentation/power/power_supply_class.txt
> > 
> > * All voltages, currents, charges, energies, time and temperatures in uV,
> > * uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
> > * stated. It's driver's job to convert its raw values to units in which
> > * this class operates.
> 
> I just now checked the hardware spec and it is indeed mAh. I will correct 
> the comment appropriately.

Note, if the hardware reports the values in mAh (milli), the driver
still have to convert them to uAh (micro) before reporting the values
to userspace.

[...]
> > I think you can use threaded irq for this.
> > 
> > See documentation for request_threaded_irq() in kernel/irq/manage.c.
> > And as an example of usage see drivers/mfd/wm8350-irq.c.
> 
> Haa that is useful information... completely missed to read about this 
> feature.

No wonder, it's just a new feature, not many know about it. ;-)

Once again, thanks for the driver!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
