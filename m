Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbZDBSXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbZDBSXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbZDBSXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:23:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:56233 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZDBSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:23:14 -0400
Date: Thu, 2 Apr 2009 11:22:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090401174336.GA14726@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org>
 <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Matthew Garrett wrote:

>> The other subtlety comes if we add fsync() suppression to laptop mode
>> --- which is something that Bart Samwel is very interested in doing
>> and I talked to him at FOSDEM about this.  As Jeff Garzik recently
>> pointed out, however, if we let the system reorder writes across
>> fsync() boundaries, or if we combine two writes to the same block
>> separated by an fsync(), and the system crashes in the middle of
>> pushing all of these blocks out to the disk, we can end up trashing
>> the consistency guarantees of a database such as mysql or postgres.
>> It's a good point, but it only applies if we add fsync() suppression
>> to laptop mode --- which we haven't done yet.
>
> I've got absolutely no idea why anyone would want fsync() to stop
> meaning "Put my data on the disk please". laptop-mode isn't intended to
> reduce data integrity - it's intended to batch disk write-outs such that
> there's a lower risk of needing to perform further write-outs in future.
> It makes sense for applications which really desperately want
> information on disk to fsync() (for instance, saving a file in
> OpenOffice).
>
> laptop-mode is something that makes sense as a default behaviour under a
> lot of circumstances. Adding fsync() suppression means it's utterly
> impossible to use it in that way. An additional mode would be perfectly
> reasonable, as long as it's made clear that it's really a request for
> data to be discarded at some point. The current mode isn't.

this issue seems pretty straightforward to me

the apps do fsync (and similar) to the degree that they think their data 
is important (potentially with config options if they acknowlege that 
their data isn't _always_ that important)

the system allows the admin to override the application and say "I'm 
willing to loose up to X seconds of data for other benifits"

if this can work cleanly (with the ordering issue that was identified, 
which may involve having multiple versions of the metadata cached) it 
seems like a very clean interface.

David Lang

