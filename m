Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZHKMJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZHKMJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZHKMJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:09:16 -0400
Received: from compulab.co.il ([67.18.134.219]:38554 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbZHKMJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:09:15 -0400
Message-ID: <4A815F64.8000105@compulab.co.il>
Date: Tue, 11 Aug 2009 15:09:08 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.21 (X11/20090712)
MIME-Version: 1.0
To: me@felipebalbi.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Question about userspace-consumer
References: <20090810200553.GB4652@gandalf> <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf>
In-Reply-To: <20090811054438.GA7176@gandalf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> On Mon, Aug 10, 2009 at 10:58:01PM +0100, Mark Brown wrote:
>> On Mon, Aug 10, 2009 at 11:05:54PM +0300, Felipe Balbi wrote:
>>
>> The existing drivers for this sort of functionality are all regular
>> kernel drivers (in drivers/power and to a lesser extent drivers/hwmon)
>> and it looks like it'd be at least as much work to rearrange the power
>> supply stuff to support userspace drivers.  My initial expectation would
> 
> power supply already does what it needs, no ? It exports battery
> figures (state-of-charge, time-to-charge, temperature, etc etc) via
> sysfs to userland, where our "charging daemon" could read those values
> from.
> 
>> be for a generic driver with some policy exposed to user space and some
>> configuration exposed for architecture code (especially for setting up
>> multi-battery board layouts and things).  That's not a terribly informed
>> opinion, though.

+1

>>> For doing that, probably userspace-consumer would have to be able to
>>> set_voltage/get_voltage, set/get_current_limit and so on. So I was
>>> thinking on changing userspace-consumer to use regulator_get() instead
>>> of regulator_bulk_get() and make each instance of userspace-consumer to
>>> talk to only and only one regulator.

I don't think that a battery charger should identify itself like a regulator
device. It seems to me that charger driver belongs completely to the power
supply subsystem and if there's a need to add policy enforcement functionality,
it should be added to the power supply subsystem.
Moreover, extending userspace-consumer driver for battery charger needs is too
dangerous. You have to ensure that *all* critical conditions are handled
in-kernel, no matter what userspace policy is.

> I think kernel should, as long as possible, only provide functionalities
> for userland to take decisions and actions, no ?
> 
> Handling policy in kernel space I find it a little odd, specially
> because different manufacturers might have different charging algorithms
> they want to implement.

It depends on how do you define policy. If the policy includes e.g. over-charge
and over-temperature than it should be handled in-kernel.

> that said, power supply framework and regulator framework seem to be
> well enough for implementing the basic support for SBS-enabled charging
> scheme.

As far as I understood SBS scheme, the host has very little impact on the
charging process. Most of the charging is handled by Smart Battery and Smart
Battery Charger without any host intervention.


-- 
Sincerely yours,
Mike.

