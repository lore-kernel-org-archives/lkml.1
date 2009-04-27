Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZD0KgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZD0KgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZD0Kfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:35:55 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59953 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZD0Kfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:35:54 -0400
Message-ID: <49F58A87.5020405@monstr.eu>
Date: Mon, 27 Apr 2009 12:35:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-21-git-send-email-monstr@monstr.eu> <1240821139-7247-22-git-send-email-monstr@monstr.eu> <1240821139-7247-23-git-send-email-monstr@monstr.eu> <1240821139-7247-24-git-send-email-monstr@monstr.eu> <1240821139-7247-25-git-send-email-monstr@monstr.eu> <1240821139-7247-26-git-send-email-monstr@monstr.eu> <1240821139-7247-27-git-send-email-monstr@monstr.eu> <1240821139-7247-28-git-send-email-monstr@monstr.eu> <1240821139-7247-29-git-send-email-monstr@monstr.eu> <1240821139-7247-30-git-send-email-monstr@monstr.eu> <20090427095815.GA12323@infradead.org>
In-Reply-To: <20090427095815.GA12323@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 27, 2009 at 10:32:18AM +0200, monstr@monstr.eu wrote:
>> +# ifdef __uClinux__
>>  struct stat64 {
>>  	unsigned long long	st_dev;
>>  	unsigned long	__unused1;
>> @@ -69,5 +69,29 @@ struct stat64 {
>>  
>>  	unsigned long	__unused8;
>>  };
>> +# else /* __uClinux__ */
>> +/* FIXME */
>> +struct stat64 {
>> +	unsigned long long	st_dev; /* Device.*/
>> +	unsigned long long	st_ino; /* File serial number.*/
>> +	unsigned int		st_mode; /* File mode.*/
>> +	unsigned int		st_nlink; /* Link count. */
>> +	unsigned int		st_uid; /* User ID of the file's owner. */
>> +	unsigned int		st_gid; /* Group ID of the file's group. */
>> +	unsigned long long	st_rdev; /* Device number, if device. */
>> +	unsigned short		__pad2;
>> +	long long		st_size; /* Size of file, in bytes. */
>> +	int			st_blksize; /* Optimal block size for I/O. */
>> +	long long		st_blocks; /* No. 512-byte blocks allocated */
>> +	int			st_atime; /* Time of last access.  */
>> +	unsigned int		st_atime_nsec;
>> +	int			st_mtime; /* Time of last modification. */
>> +	unsigned int		st_mtime_nsec;
>> +	int			st_ctime; /* Time of last status change. */
>> +	unsigned int		st_ctime_nsec;
>> +	unsigned int		__unused4;
>> +	unsigned int		__unused5;
>> +};
>> +# endif /* __uClinux__ */
> 
> Userspace ABIs must not change because of MMU vs not.
> 

:-)

I expect that someone will beat me for last two patches.

Short answer: You are right I know about.

Long answer: in stat64 structure I wanted to find out more information
about stat64 structure. I mean there are some variables and they have different
types and I would like to know about more info.
For example
If make sense long long	type for st_blocks. IMHO unsigned will be better.
And I would like to create new stat64 structure where is not a fault for both noMMU/MMU version.
In noMMU implementation is st_blocks unsigned long. Is it OK? or unsigned long long is better?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
