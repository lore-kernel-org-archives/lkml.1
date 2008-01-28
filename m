Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYA1HB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYA1HB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 02:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYA1HBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 02:01:48 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43543 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYA1HBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 02:01:47 -0500
Message-ID: <479D7DEB.7070806@austin.ibm.com>
Date: Mon, 28 Jan 2008 01:02:03 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, trivial@kernel.org,
       linux-fsdevel@vger.kernel.org, apw@shadowen.org, rdunlap@xenotime.net,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] bfs: remove multiple assignments
References: <1201296027-6900-1-git-send-email-dmitri.vorobiev@gmail.com> <1201296027-6900-9-git-send-email-dmitri.vorobiev@gmail.com> <Pine.LNX.4.61.0801261833270.1966@ginsburg.homenet> <479BC6E5.5000409@gmail.com>
In-Reply-To: <479BC6E5.5000409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> -    inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
>>> +    inode->i_mtime = CURRENT_TIME_SEC;
>>> +    inode->i_atime = CURRENT_TIME_SEC;
>>> +    inode->i_ctime = CURRENT_TIME_SEC;
>> multiple assignments like "x = y = z = value;" can potentially
>> (depending on the compiler and arch) be faster than "x = value; y =
>> value; z=value;"
>>
>> I am surprized that this script complains about them as it is a
>> perfectly valid thing to do in C.
> 
> I think it seems wise to ask the maintainers of checkpatch.pl to
> comment on that. I'm Cc:ing them now.
> 

There are plenty of things that are valid to do in C that don't make for 
maintainable code.  These scripts are designed to make your code easier for 
real people to review and maintain.

As for if this can be faster we don't deal in the realm of "can".  Please 
show a concrete example of gcc making Linux kernel code faster with 
multiple assignments per line.  If you can do that I'm willing to change my 
mind and I'll lead the charge for mutliple assignments per line.


