Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZCBSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZCBSR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZCBSRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:17:49 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:41447 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZCBSRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:17:48 -0500
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: 2.6.28 - 2.6.29-rc6-git5 regression, p4-clockmod/cpufreq probably
Date: Mon, 2 Mar 2009 20:17:30 +0200
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
       davej@redhat.com
References: <200903021704.59663.denys@visp.net.lb> <200903021833.46540.denys@visp.net.lb> <20090302172309.GC25965@silver.sucs.org>
In-Reply-To: <20090302172309.GC25965@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903022017.30886.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 19:23:09 Sitsofe Wheeler wrote:
> On Mon, Mar 02, 2009 at 06:33:46PM +0200, Denys Fedoryschenko wrote:
> > CPUFreq infrastructure much more powerful.
> > -d --min <FREQ>
> >     new minimum CPU frequency the governor may select.
> > -u --max <FREQ>
> >     new maximum CPU frequency the governor may select.
> > -g --governor <GOV>
> >     new cpufreq governor.
> >
> > This things you cannot do over inserting values over ACPI. Sure you can
> > reinvent the wheel, but why?
>
> I guess I don't understand why you would want scaling if it didn't save
> you any power...
If i will limit current in certain limits, rather than using high current, i 
will have in result higher efficiency of discharging battery.
The discharge curves for a Lithium Ion cell below show that the effective 
capacity of the cell is reduced if the cell is discharged at very high rates 
(or conversely increased with low discharge rates). This is called the 
capacity offset and the effect is common to most cell chemistries.
If the discharge takes place over a long period of several hours as with some 
high rate applications such as electric vehicles, the effective capacity of 
the battery can be as much as double the specified capacity at the C rate. 
This can be most important when dimensioning an expensive battery for high 
power use. The capacity of low power, consumer electronics batteries is 
normally specified for discharge at the C rate whereas the SAE uses the 
discharge over a period of 20 hours (0.05C) as the standard condition for 
measuring the Amphour capacity of automotive batteries. The graph below shows 
that the effective capacity of a deep discharge lead acid battery is almost 
doubled as the discharge rate is reduced from 1.0C to 0.05C. For discharge 
times less than one hour (High C rates) the effective capacity falls off 
dramatically. 
This means even i need to recode on battery movie (clearly need same amount of 
processing power), if i do it with 100% CPU available let's say in 30 
minutes, and if i do it with 50% CPU available in 60 minutes, at the end i 
should have DIFFERENT amount of remaining battery.

Another example, if i run screensaver i want governor powersave(so some crazy 
flash plugin don't dry out battery till i come back) , if i run on battery i 
will put conservative and limit frequency range to max 50% of CPU power, so i 
can be sure my laptop lasts enough time. This in case battery time matter for 
me more than computing power. Sure i will prefer some universal way, so i can 
set same rules on Core 2 Duo based laptop, and cheap Celeron. Cpufreq provide 
me useful framework for this job, and important SAME API everywhere. Less 
efficient on p4-clockmod, and very efficient on true "mobile" processors.

* Many things quoted from http://www.mpoweruk.com/performance.htm
