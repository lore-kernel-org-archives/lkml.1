Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZDCA4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZDCA4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbZDCAzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:55:55 -0400
Received: from mail.lang.hm ([64.81.33.126]:56263 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZDCAzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:55:55 -0400
Date: Thu, 2 Apr 2009 17:55:11 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090402234617.GB9538@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm>
References: <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org>
 <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Matthew Garrett wrote:

> On Thu, Apr 02, 2009 at 11:44:20AM -0700, david@lang.hm wrote:
>> On Thu, 2 Apr 2009, Matthew Garrett wrote:
>>> The solution to "fsync() causes disk spinups" isn't "ignore fsync()".
>>> It's "ensure that applications only use fsync() when they really need
>>> it", which requires us to also be able to say "fsync() should not be
>>> required to ensure that events occur in order".
>>
>> ignore the issue of order on the local disk for the moment.
>>
>> what should an application do to make sure it's data isn't lost?
>
> fsync().
>
>> however, some (many, most??) users would probably be willing to loose a
>> little e-mail to gain a significant increase in battery life on their
>> laptops.
>
> Then they shouldn't use a mail client that fsync()s.

so they need to use one mail client when they want to have good battery 
life and a different one when they are plugged in to power?

>> today they have no choice (other than picking a mail client that doesn't
>> try to protect it's local data)
>>
>> with the proposed addition to laptop mode (delaying fsync until the disk
>> is awake), the user (or more precisely the admin) gains the ability to
>> define this trade-off rather than depending on the application developers
>> all doing this right.
>
> No. Ignoring fsync() makes it difficult for an application to
> inappropriately spin up a disk - but it also makes it *impossible* for
> an application to save data that it genuinely needs to. Doing this in
> kernel means that you have no granularity. You ignore the inappropriate
> fsync()s, but you also ignore the ones that are vitally important. I've
> no objection to the kernel supporting this functionality, but it should
> be /proc/sys/vm/fuck-my-data-harder rather than
> /proc/sys/vm/laptop-mode.
>
> Power management is a tradeoff. Sometimes providing correct
> functionality costs more than providing incorrect functionality. In
> general we strive to carry on providing applications the behaviour they
> expect even if it costs us more power - the alternative leads to users
> disabling power management functionality because they can't trust it.
> Throwing data away isn't an acceptable tradeoff for an extra three
> minutes of battery life for most users.

I would agree with you if it was three minutes of battery life, but what 
if it's an extra hour? (easily possible if the fsyncs make the difference 
between the drive running all the time and waking up every 5 min for a few 
seconds)

David Lang
