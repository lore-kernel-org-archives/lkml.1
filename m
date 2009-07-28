Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZG1Hth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZG1Hth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZG1Hth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:49:37 -0400
Received: from bamako.nerim.net ([62.4.17.28]:64821 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZG1Htg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:49:36 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 03:49:36 EDT
Date: Tue, 28 Jul 2009 09:26:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 12/22] hwmon: WM831x PMIC hardware 
 monitoring  driver
Message-ID: <20090728092647.23ff0eaa@hyperion.delvare>
In-Reply-To: <20090727204614.GA4386@sirena.org.uk>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
	<1248702372-29534-12-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20090727214419.5a503821@hyperion.delvare>
	<20090727204614.GA4386@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 21:46:14 +0100, Mark Brown wrote:
> On Mon, Jul 27, 2009 at 09:44:19PM +0200, Jean Delvare wrote:
> > On Mon, 27 Jul 2009 14:46:02 +0100, Mark Brown wrote:
> > > +#define WM831X_NAMED_VOLTAGE(id, name) \
> > > +	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage,\
> > > +				  NULL, name);		\
> > 
> > I guess you could just call WM831X_VOLTAGE(id, name).
> 
> That clashes with the unnamed voltage above.  I could also call them
> _NAMED and _UNNAMED, I suppose.

Sorry for not being clear. I simply meant you could write the following:

define WM831X_VOLTAGE(id, name) \
	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage, \
				  NULL, name)

#define WM831X_NAMED_VOLTAGE(id, name) \
	WM831X_VOLTAGE(id, name);					\
	static SENSOR_DEVICE_ATTR(in##id##_label, S_IRUGO, show_label,	\
				  NULL, name)

Which makes it more obvious that WM831X_NAMED_VOLTAGE is WM831X_VOLTAGE
+ label. But it's really up to you which way you prefer.

-- 
Jean Delvare
