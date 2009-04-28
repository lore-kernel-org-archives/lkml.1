Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbZD1LIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbZD1LIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbZD1LIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:08:16 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:65321 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZD1LIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qvS7pmdWUsyiwgr/e4nF15j5EC6IOboAkzRpUKCwBWj1pjx9pTXCRXVP+oST580wP7
         qKlAo7lnCkDc+M7b3aJvViyg15k2Uw5crn3I/4nxua3olTcIGI1gk/hOGw0i1+2aKw0I
         0+EHYI9FFz6Cyb0u1R+i4vncdu/lgZAfuFJ/s=
MIME-Version: 1.0
In-Reply-To: <1240915882.15414.3.camel@localhost>
References: <2a27d3730904280316l7049bddbie914907b16ccfff6@mail.gmail.com>
	 <1240913737-23773-1-git-send-email-leoli@freescale.com>
	 <1240913737-23773-2-git-send-email-leoli@freescale.com>
	 <1240913737-23773-3-git-send-email-leoli@freescale.com>
	 <1240913737-23773-4-git-send-email-leoli@freescale.com>
	 <1240913737-23773-5-git-send-email-leoli@freescale.com>
	 <1240915882.15414.3.camel@localhost>
Date: Tue, 28 Apr 2009 19:08:13 +0800
X-Google-Sender-Auth: 24293894411bc033
Message-ID: <2a27d3730904280408j636d8e4tc1b6e1c827509379@mail.gmail.com>
Subject: Re: [PATCH] rio: warn_unused_result warnings fix
From: Li Yang <leoli@freescale.com>
To: michael@ellerman.id.au
Cc: akpm@linux-foundation.org, galak@kernel.crashing.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 6:51 PM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On Tue, 2009-04-28 at 18:15 +0800, Li Yang wrote:
>> warning: ignoring return value of 'device_add', declared with attribute warn_unused_result
>> warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
>>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> ---
>>  drivers/rapidio/rio-scan.c  |    5 ++++-
>>  drivers/rapidio/rio-sysfs.c |    6 ++++--
>>  2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
>> index 74d0bfa..9309e24 100644
>> --- a/drivers/rapidio/rio-scan.c
>> +++ b/drivers/rapidio/rio-scan.c
>> @@ -265,7 +265,10 @@ static void rio_route_set_ops(struct rio_dev *rdev)
>>   */
>>  static void __devinit rio_add_device(struct rio_dev *rdev)
>>  {
>> -     device_add(&rdev->dev);
>> +     int err;
>> +
>> +     err = device_add(&rdev->dev);
>> +     WARN_ON(err);
>>
>>       spin_lock(&rio_global_list_lock);
>>       list_add_tail(&rdev->global_list, &rio_devices);
>
> Is that really useful? Why not return the error to rio_setup_device()
> which can tell it's caller.

IMHO, when device_add() fails the system is quite broken.  So the
value is very limited for it to fail cleanly, which need some effort
to implement.  I can add it if you insist.

- Leo
