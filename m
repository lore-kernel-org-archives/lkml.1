Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXBWHlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXBWHlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 02:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXBWHlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 02:41:35 -0500
Received: from frosty.hhs.nl ([145.52.2.15]:47024 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXBWHle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 02:41:34 -0500
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 02:41:33 EST
Message-ID: <45DE941A.1070306@hhs.nl>
Date: Fri, 23 Feb 2007 08:13:30 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Dave Jones <davej@redhat.com>, linux-acpi@vger.kernel.org,
       notting@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz>	<45D7461A.2040808@redhat.com> <45D8D6AE.3000204@assembler.cz>	<45DB0EEA.2010205@redhat.com> <20070220191142.GE16614@redhat.com>	<20070221171737.b6592104.khali@linux-fr.org>	<20070221173740.GD19851@redhat.com>	<20070221201944.GD13794@redhat.com> <20070222173711.9364695b.khali@linux-fr.org>
In-Reply-To: <20070222173711.9364695b.khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 23022007 #257329, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Wed, 21 Feb 2007 15:19:44 -0500, Dave Jones wrote:
>> Ah, Fedora has this horror in its initscripts (which explains why I missed
>> it in my grep)..
>>
>> # Initialize ACPI bits
>> if [ -d /proc/acpi ]; then
>>     for module in /lib/modules/$unamer/kernel/drivers/acpi/* ; do
>>         module=${module##*/}
>>         module=${module%.ko}
>>         modprobe $module >/dev/null 2>&1
>>     done
>> fi
> 
> Ah, this also explains why the i2c_ec and sbs drivers were loaded on
> Chuck's system, although they were not needed.
> 
>> This is there because there's no clean way for userspace to know whether
>> to load the system specific stuff right now.   Bill Nottingham pointed
>> out that we could add a /sys/class/dmi/modalias and appropriate MODULE_DMI
>> tags to the various modules like asus_acpi to make udev autoload them.
> 
> Something similiar should be doable for i2c_ec, as it's only useful if a
> given ACPI object is present. sbs, in turn, is only useful if i2c_ec is
> loaded.
> 

I'm thinking that it might be an idea to also use this idea of udev autoloading 
through DMI info for the abituguru and abituguru3 driver (review please). The 
both only support about 12 motherboards. For the abituguru driver, dmi info 
could also be used to automatically set the module options needed on the 2 
oldest uguru featuring abit motherboards. What do you think about this?

Regards,

Hans


