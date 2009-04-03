Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbZDCBAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbZDCBAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbZDCBAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:00:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:33008 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbZDCBAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:00:12 -0400
Date: Thu, 2 Apr 2009 17:59:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090402234751.GC9538@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021755250.28893@asgard.lang.hm>
References: <200903291224.21380.info@gnebu.es> <200904030535.00335.nickpiggin@yahoo.com.au> <20090402183834.GB4773@srcf.ucam.org> <200904030556.41270.nickpiggin@yahoo.com.au> <20090402234751.GC9538@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Matthew Garrett wrote:

> On Fri, Apr 03, 2009 at 05:56:40AM +1100, Nick Piggin wrote:
>> On Friday 03 April 2009 05:38:34 Matthew Garrett wrote:
>>> On Fri, Apr 03, 2009 at 05:34:59AM +1100, Nick Piggin wrote:
>>>
>>>> Shouldn't applications have a mode to avoid spinning up the disk if it is
>>>> so important?
>>>
>>> They do. It's called "Don't use fsync() unless your data needs to be on
>>> disk". I'm not sure why you'd ever want an application to be in anything
>>> but this mode.
>>>
>>
>> Well you might decide you are willing to sacrifice timely storage of
>> logs, or reducing backups in your editor or something. But obviously
>> the kernel can't decide which of those fsyncs is safe to omit (or
>> turn into a barrier) while staying within the advertised semantics of
>> the app. Application obviously can.
>
> I'd argue that if the user cares enough that they want it fsync()ed on
> ext3 then they probably also want it fsync()ed if they're on battery.
> But yes, if anything is going to make a distinction between grades of
> "Must be saved" then it has to be the application - the kernel certainly
> doesn't have that information.

but is it the user who's deciding today or the application developer?

I agree that the kernel has no way of saying 'this fsync is important, 
that one can be ignored'

but I don't think anyone is suggesting that (everyone who has mentioned it 
in a proposal has done so saying 'this obviously is too complicated to try 
to do'

however, there is one thing about laptop mode that I need clarification 
on.

is laptop mode

A. "write everything now, don't delay writes" in the hope that the drive 
will be idle enough later to spin down

or

B. "delay all writes until later, then when the drive wakes up do all 
pending writes at that time" so that the drive can go to sleep in the 
meantime?

I've heard things in these threads that would indicate both behaviors.

David Lang
