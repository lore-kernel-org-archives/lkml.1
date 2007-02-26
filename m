Return-Path: <linux-kernel-owner+w=401wt.eu-S1030208AbXBZNIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208AbXBZNIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030214AbXBZNIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:08:47 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:32853 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030208AbXBZNIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:08:46 -0500
Message-ID: <45E2DBCD.5020006@citd.de>
Date: Mon, 26 Feb 2007 14:08:29 +0100
From: Matthias Schniedermeyer <ms@citd.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Yakov Lerner <iler.ml@gmail.com>
Cc: sfaibish <sfaibish@emc.com>, kernel list <linux-kernel@vger.kernel.org>,
       "piernas@ditec.um.es" <piernas@ditec.um.es>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>	 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <f36b08ee0702260349p284f0886n7a1987cfdd43bf55@mail.gmail.com>
In-Reply-To: <f36b08ee0702260349p284f0886n7a1987cfdd43bf55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yakov Lerner wrote:
> On 2/14/07, sfaibish <sfaibish@emc.com> wrote:
>> On Sat, 10 Feb 2007 22:06:37 -0500, Sorin Faibish <sfaibish@emc.com>
>> wrote:
>>
>> > Introducing DualFS
>> >
>> > File System developers played with the idea of separation of
>> > meta-data from data in file systems for a while. The idea was
>> > lately revived by a small group of file system enthusiasts
>> >  from Spain (from the little known University of Murcia) and
>> > it is called DualFS. We believe that the separation idea
>> > will bring to Linux file systems great value.
>> >
>> > We see DualFS as a next-generation journaling file system which
>> > has the same consistency guaranties as traditional journaling
>> > file systems but better performance characteristics. The new file
>> > system puts data and meta-data on different devices (usually, two
>> > partitions on the same disk or different disks)
> 
> Do you guys have an option of using just one partiton, and
> divide it into two fixed parts at mkfs-time , one part X% (for metadata)
> and  2nd part at (100-X)% (file file  blocks) ? Would not this option
> be easier-to-administer choice for naive users ? Or, you do not
> view your FS as an option for naive users in the first place ?

Personally i would prefer to put the metadata-part as a file inside another filesystem.
- The files can shrink and grow as needed
- If you have several Partitions like that you don't have that much overhead because of fixed size metadata

For e.g. I have 41 external HDDs (11TB, currently with XFS), when i could split the metadata from the actual data.
And when it would be possible to mount the metadata without it's data i would gain the following niceties.
- I could gather all metadata in one place
- No "overhead" for filesystem on the external HDDs just "pure" data.
- They would be searchable, at least on the metadata level, so i could search something and then connect the needed HDD for full access.

In my case the metadata overhead should be quite small as the smallest file is about 400MB and range up to 5GB. For e.g. i have HDDs which are full by only about 90 files.
The file are mostly write-once, so the current overhead for dualfs would be 'extreme' for my case.
AFAIR the overhead of XFS (with log reduced to near minimum) was about 4-5MB in total for a 200GB HDD. But i'm currently at work so i can't verify that.



-- 
Real Programmers consider "what you see is what you get" to be just as
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated,
cryptic, powerful, unforgiving, dangerous.

