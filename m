Return-Path: <linux-kernel-owner+w=401wt.eu-S1422766AbXCOAJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422766AbXCOAJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422768AbXCOAJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:09:13 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:42299 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422766AbXCOAJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:09:12 -0400
Message-ID: <45F88E8B.90403@s5r6.in-berlin.de>
Date: Thu, 15 Mar 2007 01:08:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: oops in __nodemgr_remove_host_dev (was Re: Ooops with suspend
 to RAM)
References: <200703140642.28390.ismail@pardus.org.tr> <200703141858.39531.ismail@pardus.org.tr> <45F83E14.3060003@s5r6.in-berlin.de> <200703150051.29945.ismail@pardus.org.tr>
In-Reply-To: <200703150051.29945.ismail@pardus.org.tr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ismail Dönmez wrote:
> On Wednesday 14 March 2007 20:25:24 Stefan Richter wrote:
>> Ismail Dönmez wrote:
>> > Are you able to rmmod it?
>>
>> Yes, but on 2.6.20 and earlier kernels, most of the time with
>> development versions of the 1394 drivers. I still haven't tried
>> 2.6.21-rc, will hopefully get to it tonight.
> 
> Ok then that explains a bit, without suspend if I rmmod ohci1394 module I got 
> the exact oops.

Elsewhere, Adrian Bunk wrote:
| Is this an old problem, or what was the last kernel that worked
| for you?

Adrian,

according to a quick test I made right now it is a regression post 2.6.20.
# modprobe ohci1394   # wait a bit, eth1394 is auto-loaded
# modprobe -r eth1394
# modprobe -r ohci1394
works.
# modprobe ohci1394   # wait a bit, eth1394 is auto-loaded
# modprobe -r ohci1394
oopses with the same trace as Ismael posted. And indeed, looking at his
trace once more I now also spot eth1394 among his linked-in modules.

Ismail, if you have the opportunity, the next thing you could test would
be to unload eth1394 explicitly before ohci1394 on 2.6.21-rc3. This
would _not_ oops according to my observation.

Thanks to Ismail's link to the similar report on 2.6.19-rc5-mm2 we
already have a hot candidate to be the trigger (not necessarily to be
the actual bug):
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=43cb76d91ee85f579a69d42bc8efc08bac560278
"Network: convert network devices to use struct device instead of
class_device"

Alas I didn't remember that older 2.6.19-rc5-mm2 discussion when I saw
Greg's pull request with this conversion patch (February 7) and didn't
react and test Linus' newest.

Advice would be appreciated...
-- 
Stefan Richter
-=====-=-=== --== -====
http://arcgraph.de/sr/
