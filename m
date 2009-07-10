Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZGJD0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZGJD0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZGJD0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:26:12 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:20643 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750851AbZGJD0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:26:11 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: XSwdL8sVM1lyKl8Gclts7qv6OuejZgqXEk1qrleYLoamlB03kaHWuuf3t9iobMePN5.OB8Tn0ykktkMzqi_alyytl8ca8LoEJW.69YMF8bVSxJ.n9aosi24cSopQfz0v1SJpF7LznQwF2L5hQP9g5grcsoRL5kberOOxfoT4Fbz1DzLtrveTdFwOll0jn4LFTVrdVRmjBDqECQiUETiJJLchmU7D63P6kLgQZ5.Pm96iYLPRt4lR9imdpeM5rNt8_en8RFFu0p2BwQ9WB9qiPCQUBKEadKkEptsxhRg.9DSHZemYWXiQHpmVEGPY5B4cGBFi
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A56B4B3.2030400@schaufler-ca.com>
Date: Thu, 09 Jul 2009 20:25:39 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: Greg KH <gregkh@suse.de>, jmorris@namei.org, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>	 <4A554B95.6070709@schaufler-ca.com> <1247160404.4398.218.camel@localhost>	 <20090709175049.GA26378@suse.de> <1247167976.4398.231.camel@localhost>
In-Reply-To: <1247167976.4398.231.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> On Thu, 2009-07-09 at 10:50 -0700, Greg KH wrote:
>   
>> On Thu, Jul 09, 2009 at 01:26:44PM -0400, David P. Quigley wrote:
>>     
>>> I just read over Casey's comments again and I'm pretty sure we have a
>>> big misunderstanding here. From his initial response it seems that he
>>> thinks that I am exposing the secids to userspace as the way for setting
>>> the labels on files. That isn't true. We are still using the full string
>>> based labels for the userspace interface what the secid is used for is
>>> to allow the kernel to keep track of changes until the sysfs_dirent is
>>> destroyed. 
>>>       
>> Ok, if Casey and others agree that this is the best solution, I'll take
>> it.
>>
>> thanks,
>>
>> greg k-h
>>     
>
>
> I haven't heard from Casey since his last email so I'd hold off on
> taking this until we come to an agreement.

Yeah. Pardon the day job.

>  It seems though from your
> comments in another mail that putting the persistent data into the
> sysfs_dirent is the proper approach and we just need to figure out what
> to put there.
>   

Now that I've really had a chance to review the patches carefully
my worst fears have been put to rest. I don't doubt that what you've
got will work any longer. I do object to using a secid, but I've had
to give in on that before.

If your secid is valid at any given time you have a context (which
is a text string) available at the same time that you can point to.
If this were not true a call to security_xattr_to_secid() could
not be counted on to succeed. You could define
security_xattr_to_secctx() and have it return the Smack value for
Smack and the context for SELinux instead of security_xattr_to_secid().
Sure, you've got a string to maintain, but it had better not be going
away in SELinux, because if it does the secid is going with it. Unless
I recall incorrectly (always a possibility) it has been some time
since the avc could really be considered a cache. I am willing to
bet beers that you could safely point to a mapping somewhere and
not worry much about it.

If not, you've got other performance issues in SELinux.
