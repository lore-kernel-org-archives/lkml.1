Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbYA2Sh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbYA2Sh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYA2Shs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:37:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44963 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYA2Shr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:37:47 -0500
Date: Tue, 29 Jan 2008 10:41:29 -0800
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <markus.rechberger@amd.com>
Cc: Matt_Domsch@dell.com, Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       Douglas_Warzecha@dell.com, Abhay_Salunke@dell.com,
       linux-kernel@vger.kernel.org,
       Michael E Brown <Michael_E_Brown@dell.com>, Greg KH <gregkh@suse.de>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: FW: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080129184129.GA23681@kroah.com>
References: <E9909A75A543064DB66E55B8E3BE41EC5FD218@ausx3mps307.aus.amer.dell.com> <479F3F60.8050108@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F3F60.8050108@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 03:59:44PM +0100, Markus Rechberger wrote:
>> -----Original Message-----
>> From: Greg KH [mailto:gregkh@suse.de] Sent: Tuesday, January 29, 2008 
>> 12:44 AM
>> To: Brown, Michael E
>> Cc: Jos?? Luis Tall??n; Warzecha, Douglas; Salunke, Abhay;
>> linux-kernel@vger.kernel.org; Domsch, Matt; marcel@holtmann.org
>> Subject: Re: 2.6.24 breaks BIOS updates on all Dell machines
>>
>> On Tue, Jan 29, 2008 at 12:32:44AM -0600, Michael E Brown wrote:
>>   
>>> BIOS updates are broken on all Dell systems due to Commit
>>> 109f0e93b6b728f03c1eb4af02bc25d71b646c59, which is now in 2.6.24.
>>>
>>>   static inline void fw_setup_device_id(struct device *f_dev, struct
>>> device *dev)
>>>   {
>>> -       /* XXX warning we should watch out for name collisions */
>>> -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
>>> +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s",
>>> dev->bus_id);
>>>  }
>>>
>>> Two programs are broken by this change:     1) dellBiosUpdate, which is 
>>> part of libsmbios
>>>     2) All of the Dell Update Packages (DUPs) that are part of Dell
>>> OpenManage: each BIOS release for each of 3-4 dozen platforms.
>>>
>>> These programs are broken due to the pathname change from
>>> /sys/class/firmware/dell_rbu/   to
>>> /sys/class/firmware/firmware-dell_rbu/loading. 
>>> Realistically, I can fix libsmbios in a couple of weeks, but there is
>>>     
>> no
>>   
>>> way that we can go back and fix a couple hundred DUP packages for this
>>> change. If this stays, we are looking at over 6 months before we have
>>>     
>> an
>>   
>>> officially-available Dell OpenManage that can deal with it, and that
>>> would be for new BIOS releases only, I suspect.
>>>
>>> Some of the relevant threads from when this was submitted and
>>>     
>> accepted:
>>   
>>> http://lkml.org/lkml/2005/5/23/73
>>> http://lkml.org/lkml/2005/5/23/62
>>>
>>> Due to the extremely large and disruptive nature of this bug, it would
>>> be nice to get a 2.6.24.1 with this patch reverted.
>>>
>>> I have copied the relevant developers at Dell who maintain this
>>>     
>> driver.
>>   
>>> Please preserve the cc: list when replying.
>>>     
>>
>> Fair enough, I have no problem reverting this.
>>
>> Anyone want to keep it in?
>>
>>   
> Hi Greg,
>
> reverting this breaks support for several media (DVB/V4L) devices. I would 
> have to look up some bugreports the same name collision happened with 
> several different drivers.
> There was a comment in the fw code to watch out for name collisions earlier 
> already, so it needs a fix somewhere.
>
> Here's some history:
> http://mcentral.de/wiki/index.php5/Bugtracker#i2c_dev_problem

Yes, but we can't break existing code that has been working for quite
some time.  That's just unacceptable.  The i2c devices can fix things by
changing their module names so this collision doesn't happen :)

So, I'm all for reverting this patch.

And then, feel free to revisit the problem by proposing something that
doesn't break existing users of the interface.

Michael, can you please send me a patch, and CC: stable@kernel.org so we
make sure to get this into 2.6.24.1?

thanks,

greg k-h
