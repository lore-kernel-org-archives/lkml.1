Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZBUNGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZBUNGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZBUNFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:05:42 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:35970 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZBUNFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:05:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CN7YAOwgm7x/yMEGqVnlAaQtHcTdG0kY2doSMm0KEGJA2RjYi8x2z8Y5WQW70wqh0/
         5VSYPN3uL0nxjpg2sakmxnHCo5Y9xPpbwALCH8hurgKz+21ZYzmWv8ybFQ6ArcQsjBfX
         b6q3JDXus/WSP87xBACbW05KQVm6msMBPKWBo=
Message-ID: <499FFC1A.7010906@gmail.com>
Date: Sat, 21 Feb 2009 14:05:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: bus.c, fix error handling in acpi_bus_init
References: <1234731354-7472-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.2.00.0902202352551.19156@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902202352551.19156@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.2.2009 05:58, Len Brown wrote:
> On Sun, 15 Feb 2009, Jiri Slaby wrote:
>
>> There was a misplaced status test. Move it to correct place and
>> rollback appropriately.
>
> hmm, looks like this has been broken since the day
> acpi_os_initialize1() was invented in 2004.

It comes from bitkeeper times, I checked, it looked like a typo.

> Turns out that the bug and its fix are moot, however,
> as acpi_os_initialize1() is hard-coded to return success,
> opting for BUG_ON() if it sees a failure...

BUG_ON is not noreturn e.g. on embedded, anyway it would crash later in 
this case. I was thinking about returning a failure when one of them is 
NULL, but fell back to not do so and check only retval in the caller.

> So unless that changes, I'd prefer to keep the code
> simple and just not check its status -- which is effectively
> what we're doing right now.

Ok, no problem. Will repost.

Thanks.
