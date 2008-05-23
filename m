Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYEWSJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYEWSJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbYEWSIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:08:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36567 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYEWSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:08:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48370825.9070304@s5r6.in-berlin.de>
Date: Fri, 23 May 2008 20:08:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Push ioctl BKL down into the i2c code
References: <20080522222327.1af72794@core>	<20080523093545.175c769c@hyperion.delvare>	<48368466.5040600@s5r6.in-berlin.de> <20080523195302.42846394@hyperion.delvare>
In-Reply-To: <20080523195302.42846394@hyperion.delvare>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 23 May 2008 10:46:30 +0200, Stefan Richter wrote:
>> AFAIU it's a preparation for
>> 
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ ?? @@ struct file_operations {
>>  	unsigned int (*poll) (struct file *, struct poll_table_struct *);
>> -	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
>>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>>
>> Obvious benefits:
>>   - No new .ioctl()s.
> 
> I fail to see how this is related to the locking change.

I meant:  After struct file_operations.ioctl is removed, developers can 
only implement unlocked_ioctl methods.  This includes code that is not 
(yet) in mainline.  To keep it compilable, it has to be converted to 
unlocked_ioctl.

[The quickest kind of conversion is to replace the ioctl method by an 
unlocked_ioctl method which itself takes the BKL.  This kind of 
conversion has of course no direct benefit for the functioning of the 
kernel, but as mentioned it at least puts the BKL issue into the line of 
sight of the people who work with the code.]
-- 
Stefan Richter
-=====-==--- -=-= =-===
http://arcgraph.de/sr/
