Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZAIXiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZAIXiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZAIXh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:37:57 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:35851 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZAIXh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:37:56 -0500
Message-ID: <4967DF86.6040709@oracle.com>
Date: Fri, 09 Jan 2009 15:36:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Pavel Machek <pavel@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
       Theodore Tso <tytso@mit.edu>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       linux-doc@vger.kernel.org, Trivial patch monkey <trivial@kernel.org>
Subject: Re: [patch] document ext3 a bit better
References: <20090103123813.GA1512@ucw.cz> <20090104023211.GJ4758@mit.edu> <20090104223433.GC1913@elf.ucw.cz> <20090105145713.GB4116@mit.edu> <20090106092156.GA13737@elf.ucw.cz> <alpine.LNX.1.10.0901100023020.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901100023020.5377@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4967DF8A.0053:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 6 Jan 2009, Pavel Machek wrote:
> 
>> On Mon 2009-01-05 09:57:13, Theodore Tso wrote:
>>> On Sun, Jan 04, 2009 at 11:34:33PM +0100, Pavel Machek wrote:
>>>> @@ -14,6 +14,11 @@ Options
>>>>  When mounting an ext3 filesystem, the following option are accepted:
>>>>  (*) == default
>>>>  
>>>> +ro			Mount filesystem read only. Note that ext3 will replay
>>>> +			the journal (and thus write to the partition) even when
>>>> +			mounted "read only". "ro, noload" can be used to prevent
>>>> +			writes to the filesystem.
>>> I'd sugest "ro,noload" since the spaces screw up the mount options
>>> parsing both on the command-line and in /etc/fstab.  So how about:
>>>
>>> 	Using the mount options "ro,noload" can be used....
>> Too many "using", but yes, fixed, thanks.
>>
>>>> @@ -95,6 +102,8 @@ debug			Extra debugging information is s
>>>>  errors=remount-ro(*)	Remount the filesystem read-only on an error.
>>>>  errors=continue		Keep going on a filesystem error.
>>>>  errors=panic		Panic and halt the machine if an error occurs.
>>>> +			(Note that default is overriden by superblock
>>>> +			setting on most systems).
>>> The default is always specified by the superblock setting.  So users
>>> will probably find it easier to understand if we remove the "(*)" and
>>> to add the explanatory comment:
>>>
>>> 			(These mount options override the errors behavior
>>> 			specified in the superblock, which can be configured
>>> 			using tune2fs)
>>>
>>> Pavel, thanks for working on improving the documentation; with these
>>> fixes,
>> Thanks!
>>
>> ---
>>
>> ext3 has quite unexpected semantics or "ro" and defaults are
>> not what they are documented to be, due to mkfs override.
>>
>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
>> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
>> index 9dd2a3b..49c08bf 100644
>> --- a/Documentation/filesystems/ext3.txt
>> +++ b/Documentation/filesystems/ext3.txt
>> @@ -14,6 +14,11 @@ Options
>>  When mounting an ext3 filesystem, the following option are accepted:
>>  (*) == default
>>  
>> +ro			Mount filesystem read only. Note that ext3 will replay
>> +			the journal (and thus write to the partition) even when
>> +			mounted "read only". Mount options "ro,noload" can be
>> +			used to prevent writes to the filesystem.
>> +
>>  journal=update		Update the ext3 file system's journal to the current
>>  			format.
>>  
>> @@ -27,7 +32,9 @@ journal_dev=devnum	When the external jou
>>  			identified through its new major/minor numbers encoded
>>  			in devnum.
>>  
>> -noload			Don't load the journal on mounting.
>> +noload			Don't load the journal on mounting. Note that this forces
>> +			mount of inconsistent filesystem, which can lead to
>> +			various problems.
>>  
>>  data=journal		All data are committed into the journal prior to being
>>  			written into the main file system.
>> @@ -92,9 +99,12 @@ nocheck
>>  
>>  debug			Extra debugging information is sent to syslog.
>>  
>> -errors=remount-ro(*)	Remount the filesystem read-only on an error.
>> +errors=remount-ro	Remount the filesystem read-only on an error.
>>  errors=continue		Keep going on a filesystem error.
>>  errors=panic		Panic and halt the machine if an error occurs.
>> +			(These mount options override the errors behavior
>> +			specified in the superblock, which can be 
>> +			configured using tune2fs.)			
>>  
>>  data_err=ignore(*)	Just print an error message if an error occurs
>>  			in a file data buffer in ordered mode.
>>
> 
> So, documentation guys, are you going to take this patch through the 
> Documentation tree (tytso already Signed off on that), or should I take it 

                     (probably should be Acked-by or Reviewed-by
                      if he isn't merging it)

> through trivial tree?

I'm so far behind on doc patches that I haven't read any of this thread
yet, so you can merge it IMO.

Thanks,
-- 
~Randy
