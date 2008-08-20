Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYHTW3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYHTW3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYHTW2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:28:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57086 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYHTW2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:28:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48AC9A72.4040808@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 00:28:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: David Moore <dcm@MIT.EDU>
CC: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: new driver staged in linux1394-2.6.git
References: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de>	 <20080820201106.GC10526@kroah.com>  <48AC8167.1020302@s5r6.in-berlin.de> <1219267012.26135.14.camel@dmoore.corp.google.com>
In-Reply-To: <1219267012.26135.14.camel@dmoore.corp.google.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Moore wrote:
> On Wed, 2008-08-20 at 22:41 +0200, Stefan Richter wrote:
>> Greg KH wrote:
>>> This assumes that it will not be dropped by you :)
>> I'll carry it until mainline merge, unless bigger subsystem changes 
>> happen on the v4l-dbv front that make it necessary to move it to their repo.
> 
> If I understand correctly, this driver is based on the legacy ieee1394
> subsystem.  I'm curious, is there a plan to migrate it to juju, where
> presumably it could be a lot cleaner and might not even have to live in
> the kernel at all (except for the need for some sort of dvb loopback
> device which might not yet exist)?

Yes; these are good points.  I planned on commenting on exactly these 
points when we (the two or so people who currently work on the driver 
and I) have it cleaned up so that we can post code for pre-merge review. 
Anyway, this is what I think:

Indeed, this driver interfaces with the ieee1394 stack.  That's because 
it lived out of tree for actually a few years already.  And of course it 
needs to be ported over to the firewire stack.  But in my opinion, this 
port is easier to do _after_ the driver came into mainline.  The 
firewire stack is still evolving, hence driver development on top of it 
outside of mainline would involve avoidable churn.

As to whether this should or could be a userland driver:  This is an 
AV/C driver, hence taking this into the kernel means that we partially 
duplicate the already existing userland library code in this area, which 
saw a lot of development and usage with a considerable range of AV/C 
devices.  It also means that we go against what has been the trend so 
far, i.e. that AV/C related code is removed from the kernel (amdtp and 
cmp long gone, dv1394 bitrotting).  So from the FireWire side, 
everything speaks against a kernel implementation of this driver.  But 
from the DVB side, there is one good reason to do it in-kernel:  That 
way it can interface with all existing DVB related userland just like 
PCI DVB cards and USB DVB cards.

A DVB loopback driver does not exist to my knowledge, nor am I aware of 
solid plans in this direction.  v4l-dvb people, please correct me if I 
missed something.

Is there interest to come up with a loopback driver for other DVB device 
types?  I presume it wouldn't make a lot of sense for PCI devices, and I 
understood that it is not feasible for USB devices for the time being.

In the past, there were also latency issues speaking against a userland 
implementation of firesat/firedtv.  These issues may be only partly 
relevant today, or maybe not at all.  An -rt kernel would surely allow 
for a low latency userspace driver; I don't know how well stock kernels 
currently do.
-- 
Stefan Richter
-=====-==--- =--- =-=--
http://arcgraph.de/sr/
