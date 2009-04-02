Return-Path: <linux-kernel-owner+w=401wt.eu-S1761799AbZDBVri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761799AbZDBVri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZDBVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:47:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:50036 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZDBVr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:47:29 -0400
Date: Thu, 2 Apr 2009 14:47:05 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <200904030535.00335.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0904021442420.28893@asgard.lang.hm>
References: <200903291224.21380.info@gnebu.es> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <200904030535.00335.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Nick Piggin wrote:

> On Friday 03 April 2009 05:22:48 david@lang.hm wrote:
>> On Wed, 1 Apr 2009, Matthew Garrett wrote:
>>
>>>> The other subtlety comes if we add fsync() suppression to laptop mode
>>>> --- which is something that Bart Samwel is very interested in doing
>>>> and I talked to him at FOSDEM about this.  As Jeff Garzik recently
>>>> pointed out, however, if we let the system reorder writes across
>>>> fsync() boundaries, or if we combine two writes to the same block
>>>> separated by an fsync(), and the system crashes in the middle of
>>>> pushing all of these blocks out to the disk, we can end up trashing
>>>> the consistency guarantees of a database such as mysql or postgres.
>>>> It's a good point, but it only applies if we add fsync() suppression
>>>> to laptop mode --- which we haven't done yet.
>>>
>>> I've got absolutely no idea why anyone would want fsync() to stop
>>> meaning "Put my data on the disk please". laptop-mode isn't intended to
>>> reduce data integrity - it's intended to batch disk write-outs such that
>>> there's a lower risk of needing to perform further write-outs in future.
>>> It makes sense for applications which really desperately want
>>> information on disk to fsync() (for instance, saving a file in
>>> OpenOffice).
>>>
>>> laptop-mode is something that makes sense as a default behaviour under a
>>> lot of circumstances. Adding fsync() suppression means it's utterly
>>> impossible to use it in that way. An additional mode would be perfectly
>>> reasonable, as long as it's made clear that it's really a request for
>>> data to be discarded at some point. The current mode isn't.
>>
>> this issue seems pretty straightforward to me
>>
>> the apps do fsync (and similar) to the degree that they think their data
>> is important (potentially with config options if they acknowlege that
>> their data isn't _always_ that important)
>>
>> the system allows the admin to override the application and say "I'm
>> willing to loose up to X seconds of data for other benifits"
>>
>> if this can work cleanly (with the ordering issue that was identified,
>> which may involve having multiple versions of the metadata cached) it
>> seems like a very clean interface.
>
> It isn't just about ordering of writes a a filesystem. A database program
> commits a transaction and then tells the client that it is safe. Client
> then goes and does <something> in response to that, which may or may not
> involve more writes to the filesystem.
>
> Shouldn't applications have a mode to avoid spinning up the disk if it is
> so important?

why should every application have to have a "I'm mobile" config option?

what about a user that's only mobile sometimes and wants full protection 
the rest of the time? how can they easily switch every application between 
'keep the data as safe as you can' and 'save battery' modes? will you have 
to restart all the apps when you unplug power to switch their modes?

allowing the user to tell the system to override the applications when the 
user wants to is _much_ easier.

David Lang
