Return-Path: <linux-kernel-owner+w=401wt.eu-S965945AbXCPVLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965945AbXCPVLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965949AbXCPVLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:11:35 -0400
Received: from fallback-mx.in-berlin.de ([192.109.42.17]:49618 "EHLO
	fallback-mx.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbXCPVLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:11:34 -0400
X-Greylist: delayed 5020 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 17:11:34 EDT
X-Envelope-From: sr@arcgraph.de
Message-ID: <45FAF429.3040108@arcgraph.de>
Date: Fri, 16 Mar 2007 20:46:49 +0100
From: Stefan Richter <sr@arcgraph.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>
CC: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: oops in __nodemgr_remove_host_dev (was Re: Ooops with suspend
 to RAM)
References: <200703140642.28390.ismail@pardus.org.tr> <200703150051.29945.ismail@pardus.org.tr> <45F88E8B.90403@s5r6.in-berlin.de> <200703150249.04169.ismail@pardus.org.tr>
In-Reply-To: <200703150249.04169.ismail@pardus.org.tr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ismail Dönmez wrote:
> On Thursday 15 March 2007 02:08:43 Stefan Richter wrote:
> [...]
>> Ismail, if you have the opportunity, the next thing you could test would
>> be to unload eth1394 explicitly before ohci1394 on 2.6.21-rc3. This
>> would _not_ oops according to my observation.
> 
> On a clean reboot it works as expected ;
> 
> southpark cartman # rmmod eth1394
> southpark cartman # rmmod ohci1394
> southpark cartman #
> 
> No oops.

I now tested 2.6.20-rc4 with the following two commits reverted:

43cb76d91ee85f579a69d42bc8efc08bac560278
"Network: convert network devices to use struct device instead of
class_device"

40cf67c5fcc513406558c01b91129280208e57bf
"Driver core: remove class_device_rename"

I can now unload ohci1394 again while eth1394 is loaded. The reverting
patch is available at
http://me.in-berlin.de/~s5r6/linux1394/work-in-progress/revert-network-convert-network-devices-to-use-struct-device-instead-of-class_device.patch
(The server may be briefly down tonight and sometime during tomorrow.)

Next thing to do: Find a minimal fix which keeps Greg's net conversions.
-- 
Stefan Richter
-=====-=-=== --== =----
http://arcgraph.de/sr/
