Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbXJNNHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbXJNNHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 09:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXJNNHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 09:07:38 -0400
Received: from customer-vserver-jkruis-1.all2all.org ([62.58.108.47]:60358
	"EHLO jkruis.all2all.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbXJNNHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 09:07:37 -0400
X-Greylist: delayed 1850 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 09:07:37 EDT
Message-ID: <47120D65.3080008@samwel.tk>
Date: Sun, 14 Oct 2007 14:36:53 +0200
From: Bart Samwel <bart@samwel.tk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: crash@treysoft.com
CC: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: hdparm standby timeout not working for WD raptors?
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>	 <470E7B90.5060203@rtr.ca>	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>	 <470F7705.3@rtr.ca> <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>
In-Reply-To: <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Weber wrote:
> On 10/12/07, Mark Lord <lkml@rtr.ca> wrote:
>> That's interesting.
>>
>> So, either something is regularly accessing/polling the drive,
>> or it just doesn't work with the standby timer.
>>
>> Are there any interesting kernel messages being generated
>> during execution of those commands?
> 
> No messages to /var/log/messages as a result of those
> commands; I ran several times and did a sync too, just
> in case.
> 
> I very much doubt that something is regularly accessing
> the drives because I have a script that runs every 1/2 hour
> to check and log status. The drives stay "standby" for
> hours (even days) at a time unless I specifically access
> something on the RAID array. Then, they stay "active/idle"
> until I manually set them to "standby".
> 
> Anything else you'd like me to try?

Some things to check:

* Run "hdparm -I" on your drive. In the "Capabilities" section there is 
a line "Standby timer values", for some drives this mentions a device 
specific minimum. I know some drives that ignore any setting below 60 
seconds.

* I also know of quite a number of drives where hdparm -B settings 
override the -S settings, even if you set the -S settings after the 
hdparm -B settings. You could try combinations with various values of 
hdparm -B, especially 1 and 255.

Cheers,
Bart
