Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYBMOId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYBMOId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYBMOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:08:22 -0500
Received: from emulex.emulex.com ([138.239.112.1]:54456 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYBMOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:08:20 -0500
Message-ID: <47B2F9C3.8070207@emulex.com>
Date: Wed, 13 Feb 2008 09:08:03 -0500
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: ltuikov@yahoo.com
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
Subject: Re: [PATCH] enclosure: add support for enclosure services
References: <875344.96222.qm@web31808.mail.mud.yahoo.com>
In-Reply-To: <875344.96222.qm@web31808.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2008 14:08:04.0601 (UTC) FILETIME=[D9CFEE90:01C86E49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keep-it-in-user-space arguments seem fairly compelling to me.
Especially as we've pushed whole i/o subsystems out to user space
(iscsi, stgt, talked about fcoe, a lot of dm control, etc).

The functionality seems to align with Doug's sg/lsscsi utility chain
as well.  Granted, the new utility would have to be designed in such
as way that it can incorporate vendor "hardware handlers".  But, if
James has a somewhat common implementation already for a kernel
implementation, I'm sure that can be the starting point for lsscsi.

So, the main question I believe is being asked is:
- Do we need to represent this via the object/sysfs tree or can an
   outside utility be depended upon to show it ?

Note that I am not supporting:
"Vendors may choose to distribute their own applications".
For this to become truly useful, there needs to be a common tool/method
that presents common features in a common manner, regardless of whether
it is in kernel or not.

-- james s


Luben Tuikov wrote:
> Which is already the case without the SES kernel bloat.
> Case in point, the excellent user-space application
> "lsscsi" would clearly show which device is SES.
> 
> And the excellent user-space application "sg_ses" could
> control an SES device.
> 
>> The pieces I think are absolutely standard are
>>
>> 1. Actual enclosure presence (is this device in an
>> enclosure)
> 
> "lsscsi"
> 
>> 2. Activity LED, this seems to be a feature of every
>> enclosure.
> 
> So that means that it needs a kernel representation?
> If this indeed were the case, for every "feature" of every
> type of device (not only SCSI) then the kernel itself would
> be insurmountably big.
> 
>> I also think the following are reasonably standard (based
>> on the fact
>> that most enclosure standards recommend but don't
>> require this):
>>
>> 3. Locate LED (for locating the device).  Even if you only
>> have an
>> activity LED, this is usually done by flashing the activity
>> LED in a
>> well defined pattern.
>> 4. Fault.  this is the least standardised of the lot, but
>> does seem to
>> be present in about every enclosure implementation.
>>
>> All I've done is standardise these four pieces ... the
>> services actually
>> take into account that it might not be possible to do
>> certain of these
>> (like fault).
> 
> And none of this means that it needs a kernel representation.
> 
> 1. You're not "standardizing" any known, in-practice,
> kernel representation, that is already in practice and
> thusly needs a kernel representation.
> 
> 2. The kernel itself is not using nor needing this
> "representation" in order to function properly (the kernel).
> 
> Leaving control of SES devices to user-space makes both
> the kernel and the vendors happy.  All the kernel needs
> to do is expose the SES device to user-space as it currently
> does.  It makes it so much easier both to vendors and to
> the kernel to stay out of unnecessary representations.
> 
> Vendors may choose to distribute their own applications
> to control their hardware, as long as the kernel exposes
> an SES device and provides functionality, as opposed to
> policy of any kind.
> 
>     Luben
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
