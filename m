Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZG1JIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZG1JIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZG1JIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:08:21 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:49852 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZG1JIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PV7CLWPUC6ECdhOcxr/2tyZ8E+qvilrbDirFHGA+ASaE5X3aPFlf2vLzTDDkiCPRb7
         3f9fDSG+ff1IJUWGiH9pXFY0+fnmWxVNV9N7BAr6hrtv6MmzZKGT6JJCPgYWxxifuaJE
         q3EElSYiISRbwaG3v0kOOYcs0O+8Qfq4Ts3MA=
MIME-Version: 1.0
In-Reply-To: <cone.1248765902.464745.15136.1000@arca>
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
	 <cone.1247683003.40459.21332.1000@deskpiie>
	 <20090723082904.GE3997@dtor-d630.eng.vmware.com>
	 <cone.1248339143.133822.15136.1000@arca>
	 <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
	 <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
	 <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net>
	 <20090727183733.GB3044@liondog.tnic>
	 <cone.1248765902.464745.15136.1000@arca>
Date: Tue, 28 Jul 2009 11:08:19 +0200
Message-ID: <9ea470500907280208v1d8140b5v9d7d7f09df8f060f@mail.gmail.com>
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 28, 2009 at 9:25 AM, Peter Feuerer<peter@piie.net> wrote:

[..]

>>> Hmm, looking at the driver I think the only function that actually
>>> is needed is poweroff() that would turn the fan in automatic mode
>>> before shutting down. The driver does not perform any actions when
>>> resuming so why bother?
>>
>> Agreed.
>>
>> Also, the fan comes out of warm and cold reboot in mode AUTO and
>> when the driver is enabled, the fan is turned off on the next run of
>> thermal_zone_device_update() when the read out temperature is within
>> limits.
>>
>> Correct me if I'm wrong, but the only reason I see for setting the
>> fan to mode AUTO before suspending/hibernating/etc is if it is taking
>> a really long time to hibernate and write RAM image to disk and the
>> machine is getting hot during that process. Otherwise, we might just
>> as well do _nothing_ when suspending and remove all suspend/resume
>> functionality altogether, no?
>
> This is right, currently the only reason for calling the suspend /
> hibernate functions is to set the fan to auto to ensure it doesn't get
> too hot while the kernel prepares the machine to suspend / hibernate.
>
> I would like to keep the resume function too. It's a nice to see
> what's happening with verbose=1.

That's not a reason for keeping code in the kernel and raising bloat
levels unnecessarily. If the driver doesn't need to do anything on
resume, then no function is needed.

-- 
Regards/Gruss,
Boris
