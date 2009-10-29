Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbZJ2FHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbZJ2FHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZJ2FHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:07:14 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:40551 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750707AbZJ2FHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:07:13 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 5K.vFfMVM1lZQLwPD6al.1kGimGl6WcGlKPiEywtzynU6cqD4PBEfYYOEQ.CiUrRU2jBhzU8gbaU20KgL5cyITUYjzooubstV7MZ60trW9PLnEeWMGDcJr7Fe87MlW9a8OR6KFQFPXvwSVpP9TgHnMWKT9htBJDL_H_aSzrBcG9bqGioyfO1Cxwuyjo.iryPmC2Q1qIH8snZwX6TkSYPxUu9xRle4GfoSUJ10YMDIzqvfjrV74mLlbUwr8u6CRjrzWXsvPpCQZ97F5TC7Ds77LhCUtSE9x0hqmIbcCJPdmqjsdijeNJ0N5J63i1Fy_ICyzi46.1HcQGyyYpvgoQ-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AE922F9.5020506@schaufler-ca.com>
Date: Wed, 28 Oct 2009 22:07:05 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: symlinks with permissions (fwd)
References: <20091028211040.GA4182@elf.ucw.cz>
In-Reply-To: <20091028211040.GA4182@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> (I forgot to cc the list)
>
> From: Pavel Machek <pavel@ucw.cz>
> To: "Eric W. Biederman" <ebiederm@xmission.com>
> Subject: Re: symlinks with permissions
> X-Warning: Reading this can be dangerous to your mental health.
>
> Hi!
>
>   
>>>>> Part of the problem is that even  if you have read-only
>>>>> filedescriptor, you can upgrade it to read-write, even if path is
>>>>> inaccessible to you.
>>>>>
>>>>> So if someone passes you read-only filedescriptor, you can still write
>>>>> to it.
>>>>>           
>>>> Openly if you actually have permission to open the file again.  The actual
>>>> permissions on the file should not be ignored.
>>>>         
>>> The actual permissions of the file are not ignored, but permissions of
>>> the containing directory _are_. If there's 666 file in 700 directory,
>>> you can reopen it read-write, in violation of directory's 700
>>> permissions.
>>>       
>> I can see how all of this can come as a surprise.  However I don't see
>> how any coder who is taking security seriously and being paranoid about
>> security would actually write code that would have a problem with this.
>>
>> Do you know of any cases where this difference matters in practice?
>>     
>
> Actually yes, see the bugtraq post. guest was able to write to my file
> when I expected that file to be protected.
>
> According to the bugtraq discussion, people expect directory
> permissions to work.

Gawd, I hate to say this, but people have been improperly educated
if they expect directory permissions to behave thusly. You can not
count on the permissions on a directory to protect access on a file
that the directory contains a reference to. Hard links. Mount points.
/proc/8675309/fd. Passing file descriptors over sockets. Fork, for
heaven's sake. That's not how Linux directories really work.


>  /proc currently breaks that. I bet there are few
> systems in the wild that have permissions set up like that, but it is
> not easy to actually find such systems.
>
> Better fix it...
> 								Pavel
>   


Well, /proc/8675309/fd is a silly notion, but it's been around
long enough that you are going to have trouble getting rid of it
and doing so wouldn't solve the "problem" in any case.

