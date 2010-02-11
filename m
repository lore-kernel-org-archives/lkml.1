Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab0BKWPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:15:42 -0500
Received: from mailc.microsoft.com ([131.107.115.214]:44442 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab0BKWPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:15:40 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Thread-Topic: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Thread-Index: AQHKq2HENZ6t0wcb1kW/75fbKuFcg5HB8/2A//+AowA=
Date: Thu, 11 Feb 2010 22:15:08 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E8831E@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E88287@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213651.GA29557@suse.de>
In-Reply-To: <20100211213651.GA29557@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  
>> -static const char VersionDate[] = __DATE__;
>> -static const char VersionTime[] = __TIME__;
>> -static const char VersionDesc[] = "Version 2.0";
>> +static const char hv_build_date[] = __DATE__;
>> +static const char hv_build_time[] = __TIME__;
>
>This should not be needed at all, as it make absolutely no sense.

You know, you are actually right. This is leftover from when the drivers
Where standalone (before we submitted them to mainline) when customers
Build the drivers on site themselves. It helped them to know when they
Build it.

>> +/*
>> + * We use the same version numbering for all Hyper-V modules.
>> + */
>> +#define HV_DRV_VERSION           "3.0.0"
>
>Is this really needed?  Now that the code is in the kernel tree,
>shouldn't you be tracking this based on kernel release version (like 90%
>of the drivers are tracked), or is there some requirement for a version
>number?
>
>And what decides when this number is changed?  What does it "mean"?
>What is it tracking?

The definition of the versioning for us is as follows;

Field	Description	Resolution
1	Major Number 	Changes for these scenarios;
				1.	When a new version of Windows Hyper-V 
					is released.
				2.	A Major change has occurred in the 
					Linux IC's. 
				(For example the merge for the first time 
				into the kernel) Every time the Major Number 
				changes, the Minor Number and Revision number 
				are reset to 0.
2	Minor Number	Changes when new functionality is added 
				to the Linux IC's that is not a bug fix. 
				If new functionality is added to the IC's 
				that is in effect also a bug fix (in the case 
				of SMP). The new functionality will override 
				the need for changing the Revision number. 
				Every time the Minor Number changes, the 
				Revision number will be reset to 0.
				For example, The current version is on;
						3.0.4
				And SMP is added, which fixes a problem as 
				well. The new versioning will become;
						3.1.0
3	Revision		Every time a bug fix or code change is 
				done that is not a Minor or Major number 
				change, this field increases by 1.

We have had issues in the past trying to piece together what customers
Where running.

The importance of the versioning numbering like this will go away over
Time once we have the code cleaned up and have additional functionality
In a staged manner. For now we are still trying to catch up.

Would you like me to re-roll the patch to remove the DATE/TIME stuff
And add the explanation for versioning as comments to the code?

Thanks,

Hank.

