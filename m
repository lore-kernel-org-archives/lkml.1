Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYFWMef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYFWMef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYFWMe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:34:26 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40886 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYFWMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:34:25 -0400
Message-ID: <485F9877.1060902@keyaccess.nl>
Date: Mon, 23 Jun 2008 14:35:03 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs
  sensors
References: <485DA11C.7050906@keyaccess.nl>	<485DFF35.6080008@hhs.nl>	<485E505F.8010306@keyaccess.nl>	<485E61DE.6020202@hhs.nl>	<20080623120844.5f722aa6@hyperion.delvare>	<485F79C6.20507@keyaccess.nl> <20080623135704.2980078c@hyperion.delvare>
In-Reply-To: <20080623135704.2980078c@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.7 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-06-08 13:57, Jean Delvare wrote:

> On Mon, 23 Jun 2008 12:24:06 +0200, Rene Herman wrote:

>> No Jean, this is totally unacceptable. No matter how you want to call 
>> things, 2.6.26 is going to break important functionality on millions of 
>> systems and you simply do not get to do that.
> 
> No, it's not going to be the end of the world that you predict. Please
> stop being alarmist, it really doesn't help.
> 
> We are going to break hardware monitoring for users who upgrade to
> kernel 2.6.26 by themselves and have enabled option "THERMAL"

Which is an option selected by ACPI_THERMAL, for which I quoted the help 
text earlier. Basically everyone with ACPI enabled will have it enabled. 
Rather wide-spread, that is.

> and are using lm-sensors <= 2.10.6. I suspect this is a relatively
> small number of users

Yes, right. All not completely new systems, all completely new slackware 
and derived systems... "relatively" is a word very much needed here.

I really cannot believe you guys are actually arguing this. It seems 
that me being tired and short pulled this in to senseless country but 
can we please concentrate on the issue?

libsensors dictated the ABI rule that the hwmon directories must have 
device backlinks; the new ACPI Thermal Zone hwmon interface breaks that 
bit of ABI. It is not relevant that that ABI may have gotten to be as a 
result of unfortunate programming on the userspace side -- the only 
thing relevant is that it IS. lm-sensors 2 is on millions of systems out 
there. This is not meant agressively, or whatever you guys seem to want 
to read in my words, it's un undeniable fact.

> and these are also the ones who are presumably skilled enough to go
> to http://www.lm-sensors.org/, find the patch they need, and apply it
> to libsensors themselves.

At times there can obviously be situations where it's fine to require 
new userspace but in this case we have a new userspace which hasn't even 
been released yet, we have a ton of _different_ userspace depending  on 
that bit of core userspace, we have breakage of the important kind (as 
you no doubt know, sensors can be pretty vital, although admittedly it's 
not silent breakage at least) and we have an opportunity to just say 
"okay, we'll apply a 1 line patch and be done with it" which avoids any 
and all problems. Why are you arguing this?

>> Can you comment on the last patch posted? It's trivial:
>>
>> http://lkml.org/lkml/2008/6/22/243
> 
> It's trivial and wrong, so thanks but no thanks. The bug is in
> libsensors, we fix it in libsensors.

This cannot be the reason, because it's not wrong. We just need a device 
backlink. Basically, any single one will do. It's just about keeping 
lm-sensors 2 happy.

Rene.
