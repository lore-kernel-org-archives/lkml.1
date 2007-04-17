Return-Path: <linux-kernel-owner+w=401wt.eu-S1030908AbXDQWDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030908AbXDQWDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031272AbXDQWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:03:09 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3126 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030908AbXDQWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:03:06 -0400
Message-ID: <46254416.6090202@rtr.ca>
Date: Tue, 17 Apr 2007 18:03:02 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
Cc: emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com>	 <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>	 <461D54AF.3060706@redhat.com> <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com> <46253F14.4020304@rtr.ca> <462540CD.9080406@redhat.com>
In-Reply-To: <462540CD.9080406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Mark Lord wrote:
>> I'll patch it locally on my own machines, but what about the tens
>> of thousands of other Seagate notebook drive owners out there?
>>
> 
> This is a problem with Seagate specifically, spinning back up
> on receipt of some command after spindown?

No, they just seem to be affected worse by it than some other brands.
The bug is that libata/SCSI now spin-down the drive before the distro's
scripts are done with it, so it spins down, and then gets spun up again
by the distro, and then spun down again by the distro.

And along the way, one/both of the two causes a full mechanism "park",
which is hard on things if abused (like this).

Or at least that's what I recall for it.  Tejun?

2007/4/11, Chuck Ebbert <cebbert@redhat.com>:
> Jan Engelhardt wrote:
> > On Apr 11 2007 17:07, Chuck Ebbert wrote:
> >> When I reboot my notebook, it powers off and powers back on.
> >> On poweroff a loud snapping noise seems to be coming from the
> >> hard drive. Today I noticed there is no "shutdown: hda" on
> >> the console when I reboot. Whne I do a normal poweroff the
> >> message is displayed and there is no noise. Should the IDE
> >> code be changed so it always shuts down the drive? 
