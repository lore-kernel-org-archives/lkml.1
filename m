Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbZBSGvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbZBSGvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZBSGus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:50:48 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:51694 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZBSGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:50:47 -0500
MIME-Version: 1.0
In-Reply-To: <20090218183945.GA31797@suse.de>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <20090218152913.GA26448@suse.de>
	 <ac3eb2510902180745v2886ae31s2d7faeb2faedab6e@mail.gmail.com>
	 <fa686aa40902180748i2d621de1j1da7600e8cc3165f@mail.gmail.com>
	 <ac3eb2510902180753l5dc94e5dje9154eaea9d2db29@mail.gmail.com>
	 <fa686aa40902180834r2b9b8de0tcdc31c850f6323a6@mail.gmail.com>
	 <ac3eb2510902180849o6d86bbfev337e1bc203d6543e@mail.gmail.com>
	 <fa686aa40902180951q64c71581y3811062256685df7@mail.gmail.com>
	 <ac3eb2510902181032h3f9ed994s212dd8b42ddca82@mail.gmail.com>
	 <20090218183945.GA31797@suse.de>
Date: Wed, 18 Feb 2009 23:50:46 -0700
Message-ID: <fa686aa40902182250g1c4e7cb6o4d0102da35ab838b@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 11:39 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Feb 18, 2009 at 07:32:19PM +0100, Kay Sievers wrote:
>> On Wed, Feb 18, 2009 at 18:51, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > Mostly because I have no need another full struct device, and none of
>> > the files that I'm adding have any bearing on udev.  They are debug
>> > and statistical files for an embedded system that are used by the
>> > developer.  I don't want application code depending on them and I'm
>> > not interested in having them advertised.
>>
>> That's what debugfs is for.
>
> Kay is right, use debugfs for stuff like this.  Not sysfs.
>
> So sorry, I'm not going to apply the patch, and you should change your
> code to not open-code this as well.

Forgive my frustration, but I've been happily using sysfs for simple
exports of driver data (not just debug either; for tuning also) for a
while now with no indication that I've doing the wrong thing.  I
haven't found anything in Documentation or in LDDv3 that says files
should not be created at probe time.  The sysfs API is beautiful to
work with and requires less code than the equivalent debugfs
interface.  Often using it exactly matches the use case that I need;
small values, simple settings and safe, concise code.

So, I re-ask my questions:
When is it legal and when is it not legal to call
device_create_file()?  If debug only stuff belongs in debugfs, then
fair enough.  But what about when tuning controls are needed?  If I
have to create a child 'struct device', then I will do so, but I'm
still not convinced on the benefit.

Even then, I'm confused.  The KOBJ_ADD uevent is raised at
device_register() time.  However, it appear that device_create_file()
often gets called after device_register() (pci_bus_add_child() for
example).  What is the cutoff point for calling device_create_file()
so that attributes exist before the uevent (as Kay stated earlier in
this thread)?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
