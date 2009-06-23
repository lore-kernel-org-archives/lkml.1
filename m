Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZFWTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZFWTd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZFWTdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:33:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:45348 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZFWTdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=ihcZEtIf5l+HVsRoj9xEx25Hbn94MY96lmR9DvG2jQXE26Grn/gAijTskS3A7W7prh
         3LV1o5wrW00Zr3NkQU2OVi0gKA4xkZEQ0MSnBilp7VSKnKwyAqDMV9N/8P6vllwXARuF
         t1hGHgGH/9QJpEQ0WXbpBOY8iXDSMOI/d38ik=
Message-ID: <4A412CC0.6050500@laptop.org>
Date: Tue, 23 Jun 2009 15:28:00 -0400
From: "Richard A. Smith" <richard@laptop.org>
Reply-To: richard@laptop.org
Organization: One Laptop per Child
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
 add it to the olpc driver
References: <20090622234607.11f61bec@mycelium.queued.net> <20090623103717.GH5422@sirena.org.uk>
In-Reply-To: <20090623103717.GH5422@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:

> On Mon, Jun 22, 2009 at 11:46:07PM -0400, Andres Salomon wrote:
> 
>> The hardware has an extra bit that specifies that the battery is trickle
>> charging, so when determining if the battery is present/charging the TRICKLE
>> bit needs to be checked as well.  Because battery diagnostics might want to
>> know whether trickle charging is happening or not, and also because trickle
>> charging falls somewhere between charging and not charging (read: Richard got
>> mad at me when I tried to set CHARGING when in trickle charge.  He gets so
>> angry sometimes), we add a new TRICKLE status to sysfs.
> 
> To avoid confusing usere applications might it be better to add another
> piece of information with detail on the charger status rather than a new
> state?  The fact that the new state name shares a prefix with the
> regular charging state does help here but you might still confuse things
> and it makes the name of the new state in sysfs a bit awkward.
> 
> I'd also be tempted to do this the other way around and add a fast
> charge status; certainly in embedded cases trickle charging is more of a
> default state since it requires less incoming power (important if you're
> using USB) and there's less risk of damage to the battery.

On the OLPC the trickle charging really is a trickle rather than just a
slower charge rate.  To fully charge a XO battery at trickle would take
about 150 hours.

Trickle is enabled when the battery voltage has dropped outside of the
normal charging envelope.  In that zone the battery voltage curve is
very non-linear so even small currents will make the voltage rise
quickly.  Once the voltage hits the safe zone regular the normal
charging rate is enabled.

I don't have any strong feelings about what nomenclature we use to
describe it.  I just want it to be a separate identifiable state (or
status).  In (OLPCs) normal charging/discharging cycle the trickle zone 
should not be reached so its an indication that you are outside the 
envelope.  If it shows up repeatedly then its an indication that 
something is amiss.

My front line for diagnosing battery problem out in the field is a small 
script that logs various bits of info from the battery system every 10 
seconds.  If its run on a charge/recharge cycle then it gives a pretty 
good picture of whats going on with the battery.

I would prefer that the stuff returned from sysfs is unique, short yet 
descriptive.  It helps if I don't have to grovel around in multiple 
locations and do boolean logic to come up with what state of the 
charging profile is active.

That makes it easy to describe how to use the info in the diagnostic 
documentation we give to deployments and keep my simple script simple.

It also aids in my processing programs that loop over my (growing) 
collection of log files looking for trends and other statistical items.

-- 
Richard Smith  <richard@laptop.org>
One Laptop Per Child

