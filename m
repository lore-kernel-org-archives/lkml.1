Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZLOBDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZLOBDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbZLOBC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:02:59 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41255 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZLOBC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EWYF/ZJDp76qq8sSVWpV7kbHeAotl5hWJk3JC9TGKAoP2mISJobQ/egii6J7ygdlY4
         VC3UEWMO3mm0MGZ2DSe1hnSt+ovSyfDXhXQwHHLm/9gKUbBEJ1/p6vZhhtKH1TNLwAi3
         +1nmqF4oWpuhWye1dSMrbtaLEUGxI4dWR8f1w=
Message-ID: <4B26E03E.5050309@gmail.com>
Date: Mon, 14 Dec 2009 19:02:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Janos Haar <djani22@netcenter.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: HDD power up in standby
References: <315c01ca7ca7$641ff8c0$0400a8c0@dcccs>
In-Reply-To: <315c01ca7ca7$641ff8c0$0400a8c0@dcccs>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 04:22 AM, Janos Haar wrote:
> Hello list,
>
> I have posted to the common, because this theme is for more lists (ide,
> sata, scsi), i think....
>
> I know you will not like me guys, but i have one wish.... :-)
>
> I am building cheap but big storages, and after 12 drive / PC i have faced
> with one problem:
> The too much spinup current wich made by the 12-16 drive at the same time.
> In my actual case, in 12V, there is more than 2A / drive for some seconds.
>
> I know, in SCSI, there is a jumper for this, and the card can wake up the
> drives one by one, but i am using 2TB drives, and in SCSI/SAS this have
> horrible price...
> I have done some invesrtigation, and found this:
> The most of the simple sata drives handles the PUIS mode (by set
> features ata command), but unfortunately
> only the professional and expensive raid cards supports the wakeing up.
> If the cheap cards founds only 0 byte drives, this is not a problem at all,
> because linux usually not use BIOS support fortunately. :-)
> But i have found when i have spent a little time in google, and in the
> documentation, linux doesn't support PUIS.
>
> I think this would be great, and (relatively) simple to implement this
> feature.
> I can imagine in this way:
> Wake up from PUIS is disabled by default, but can be enabled by command
> line
> parameter, or compile time configuration.
> The drivers should send the wake up command one by one to the drives, waits
> for RDY DSC, and than scan the drives, and register....
>
> What do you think?

As far as I can see, if the drive reports it's in power-up in standby 
mode from the identify response, the kernel will send the command to 
spin up the drive. It might depend on whether parallel scan is enabled 
for the controller as far as whether they actually spin up one at a 
time, however.

>
> (Now i am searching for the solution to send the wakeup command by user
> program, and than do a "hotplug" in software only, but this is not an
> "elegant" solution...)
>
>
> Best Regards,
> Janos Haar
>

