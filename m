Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZG1N1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZG1N1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZG1N1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:27:37 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:45362 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZG1N1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:27:37 -0400
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com> <cone.1247683003.40459.21332.1000@deskpiie> <20090723082904.GE3997@dtor-d630.eng.vmware.com> <cone.1248339143.133822.15136.1000@arca> <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com> <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com> <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net> <20090727183733.GB3044@liondog.tnic> <cone.1248765902.464745.15136.1000@arca> <9ea470500907280208v1d8140b5v9d7d7f09df8f060f@mail.gmail.com>
Message-ID: <cone.1248787508.386883.15136.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Date: Tue, 28 Jul 2009 15:25:08 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:

> Hi,
> 
> On Tue, Jul 28, 2009 at 9:25 AM, Peter Feuerer<peter@piie.net> wrote:
> 
> [..]
> 
>>>> Hmm, looking at the driver I think the only function that actually
>>>> is needed is poweroff() that would turn the fan in automatic mode
>>>> before shutting down. The driver does not perform any actions when
>>>> resuming so why bother?
>>>
>>> Agreed.
>>>
>>> Also, the fan comes out of warm and cold reboot in mode AUTO and
>>> when the driver is enabled, the fan is turned off on the next run of
>>> thermal_zone_device_update() when the read out temperature is within
>>> limits.
>>>
>>> Correct me if I'm wrong, but the only reason I see for setting the
>>> fan to mode AUTO before suspending/hibernating/etc is if it is taking
>>> a really long time to hibernate and write RAM image to disk and the
>>> machine is getting hot during that process. Otherwise, we might just
>>> as well do _nothing_ when suspending and remove all suspend/resume
>>> functionality altogether, no?
>>
>> This is right, currently the only reason for calling the suspend /
>> hibernate functions is to set the fan to auto to ensure it doesn't get
>> too hot while the kernel prepares the machine to suspend / hibernate.
>>
>> I would like to keep the resume function too. It's a nice to see
>> what's happening with verbose=1.
> 
> That's not a reason for keeping code in the kernel and raising bloat
> levels unnecessarily. If the driver doesn't need to do anything on
> resume, then no function is needed.

I don't think the verbose message is useless. If an user has a problem with 
suspend / hibernate I can just ask him to load the module with verbose=1 and 
dmesg tells whether the module is waking up or not. Searching for such an 
error is much easier this way as the user doesn't have to recompile the 
kernelmodule. In my opinion keeping these 4 lines of code is worth it.

kind regards,
--peter
