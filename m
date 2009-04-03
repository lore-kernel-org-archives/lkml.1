Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbZDCBQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbZDCBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZDCBQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:16:49 -0400
Received: from mail.lang.hm ([64.81.33.126]:33570 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbZDCBQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:16:49 -0400
Date: Thu, 2 Apr 2009 18:16:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090403010600.GA10545@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm>
References: <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm>
 <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Matthew Garrett wrote:

> On Thu, Apr 02, 2009 at 05:55:11PM -0700, david@lang.hm wrote:
>> On Fri, 3 Apr 2009, Matthew Garrett wrote:
>>> Then they shouldn't use a mail client that fsync()s.
>>
>> so they need to use one mail client when they want to have good battery
>> life and a different one when they are plugged in to power?
>
> They need to make a decision about whether they care about their mailbox
> being precisely in sync with their server or not, and either use a
> client that adapts appropriately or choose a client that behaves
> appropriately. It's certainly not the kernel's business.

the kernel is not deciding this, the kernel would be implementing the 
user's choice

>>> No. Ignoring fsync() makes it difficult for an application to
>>> inappropriately spin up a disk - but it also makes it *impossible* for
>>> an application to save data that it genuinely needs to. Doing this in
>>> kernel means that you have no granularity. You ignore the inappropriate
>>> fsync()s, but you also ignore the ones that are vitally important. I've
>>> no objection to the kernel supporting this functionality, but it should
>>> be /proc/sys/vm/fuck-my-data-harder rather than
>>> /proc/sys/vm/laptop-mode.
>>>
>>> Power management is a tradeoff. Sometimes providing correct
>>> functionality costs more than providing incorrect functionality. In
>>> general we strive to carry on providing applications the behaviour they
>>> expect even if it costs us more power - the alternative leads to users
>>> disabling power management functionality because they can't trust it.
>>> Throwing data away isn't an acceptable tradeoff for an extra three
>>> minutes of battery life for most users.
>>
>> I would agree with you if it was three minutes of battery life, but what
>> if it's an extra hour? (easily possible if the fsyncs make the difference
>> between the drive running all the time and waking up every 5 min for a few
>> seconds)
>
> If you can demonstrate a real world use case where the hard drive
> (typically well under a watt of power consumption on modern systems)
> spindown policy will be affected sufficiently pathologically by a mail
> client that you lose an hour of battery life, then I'd rethink this. But
> mostly I'd conclude that this was an example of an inappropriate
> spindown policy.

remember that the mail client was an example.

you want another example, think of anything that uses sqlite (like the 
firefox history stuff, although that was weakened drasticly due to the 
ext3 problems).

David Lang
