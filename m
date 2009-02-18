Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZBRQeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZBRQeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZBRQeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:34:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:12365 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBRQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <ac3eb2510902180753l5dc94e5dje9154eaea9d2db29@mail.gmail.com>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <20090218152913.GA26448@suse.de>
	 <ac3eb2510902180745v2886ae31s2d7faeb2faedab6e@mail.gmail.com>
	 <fa686aa40902180748i2d621de1j1da7600e8cc3165f@mail.gmail.com>
	 <ac3eb2510902180753l5dc94e5dje9154eaea9d2db29@mail.gmail.com>
Date: Wed, 18 Feb 2009 09:34:09 -0700
Message-ID: <fa686aa40902180834r2b9b8de0tcdc31c850f6323a6@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Grant Likely <grant.likely@secretlab.ca>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 8:53 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Feb 18, 2009 at 16:48, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Wed, Feb 18, 2009 at 8:45 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> On Wed, Feb 18, 2009 at 16:29, Greg KH <gregkh@suse.de> wrote:
>>>> On Wed, Feb 18, 2009 at 08:11:34AM -0700, Grant Likely wrote:
>>>>> From: Grant Likely <grant.likely@secretlab.ca>
>>>>>
>>>>> I find myself using the pattern of device_add_attributes() and
>>>>> device_remove_attributes() frequently in my drivers.  Rather than
>>>>> reinventing the wheel every time, I'm floating this patch to export
>>>>> the symbols to see how it is received.  If this looks okay then I'll
>>>>> rework my drivers and post additional patches to use these functions.
>>>>
>>>> No objection from me, as long as the symbols are EXPORT_SYMBOL_GPL(),
>>>> like the rest of the driver core.  Is that ok with you?
>>>
>>> These functions used outside the core create attributes after the
>>> uevent is sent, and userspace will not see these files at event time.
>>> This is in most cases a pretty broken behavior. Is that the expected
>>> behavior in your drivers?
>>
>> ??? I don't follow what you mean.
>>
>> I'm using these functions to allow the driver to add device attribs;
>> primarily for debugging knobs and controls.  Userspace will see the
>> files after the driver is bound to the device.  The uevent doesn't
>> really come into play.
>
> Sure, they do. Many things expect all files which are visible at the
> device to be readable also at event time. That's the whole way udev
> and device property matching works. There are only a few exceptions
> where creating files at a device later, after it is registered with
> the core, is not a bug.

Let me make sure I understand you...

Is it a bug for a device driver to call
device_create_file()/device_remove_file() at probe time?  For example,
if I have a data capture device which is probed via the platform bus,
is it okay for the .probe() function for the driver to use
device_create_file() to add a 'rate_statistics' file which dumps out
some data rate statistics in ASCII form?

I was under the impression that
device_create_file()/device_remove_file() were okay to use at probe
time.  device_add_attributes()/device_remove_attributes() are only
wrappers around device_create_file()/device_remove_file() with error
checking and unwinding when things go wrong.

Am I incorrect here?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
