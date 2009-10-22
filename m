Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZJVVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZJVVDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZJVVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:03:24 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:46991 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZJVVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:03:24 -0400
X-Greylist: delayed 3611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2009 17:03:24 EDT
Message-id: <4AE0BA6B.50805@acm.org>
Date: Thu, 22 Oct 2009 15:02:51 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Bela Lubkin <blubkin@vmware.com>
Cc: "'Matt Domsch'" <Matt_Domsch@dell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [Openipmi-developer] [Discuss] [PATCH] ipmi: use	round_jiffies on
 timers to reduce timer overhead/wakeups
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
 <20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com>
 <20091021130348.cd521b0c.randy.dunlap@oracle.com>	<4ADF6D76.7070409@acm.org>
 <4ADF75A2.50202@linux.intel.com>
 <20091022025013.GB20467@auslistsprd01.us.dell.com>
 <E0AA796A7E3F4C4E8F1065D15FE4786183AF6948@EXCH-MBX-4.vmware.com>
In-reply-to: <E0AA796A7E3F4C4E8F1065D15FE4786183AF6948@EXCH-MBX-4.vmware.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bela Lubkin wrote:
> Matt Domsch wrote:
>
>   
>> Though I'm really curious that HP has a KCS+interrupt controller
>> available.  That gives me hope that the industry-wide problems which
>> prevented Dell from doing likewise a couple years ago are now
>> resolved.  I'll have my team look into it again.
>>     
>
> Can you expand on "industry-wide problems"?  (Forced to share
> interrupts with a high rate device?  Design your gizmo to
> support MSI/MSI-x.  Add MSI support to ipmi_si if necessary...)
>
> As far as I can tell, HP has never shipped an interrupt-less
> BMC.  Their current iLO2 BMC is KCS + interrupt.  Their older
> design was SMIC + interrupt.
>
> Why does everyone use KCS when BT is obviously better?  Can
> you have your team look into that as well?  (Among the various
> goals here, I assume that BT -- with a single interrupt and a
> DMA transfer instead of shuffling bytes over I/O ports -- would
> cost less power.  Not that the members of that list will
> receive this message: it bounces nonmembers.)
>   
This is an industry where pennies matter, apparently.

My personal preference would be to use the I2C based standard 
interface.  That actually doesn't perform too badly, it's probably 
cheaper than KCS since you already have I2C, anyway, and the I2C 
interfaces are generally tied to an interrupt.  The trouble is that the 
only hardware implementation of this I know of seems to be poorly done, 
but that mostly affects trying to use the ethernet interface and the 
local interface at the same time.

Of course, the driver for I2C is not yet in the standard kernel as it 
requires a fairly massive I2C driver rewrite to allow the IPMI driver to 
do it's panic-time operations.

BT would be better for performance, I guess, but it's yet another 
interface to tie in, and hanging this off an existing bus seems like a 
sensible thing to do.  And performance is really not an issue for IPMI.

-corey
