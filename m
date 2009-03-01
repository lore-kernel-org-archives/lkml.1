Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZCAJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZCAJrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZCAJrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:47:15 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:40983 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZCAJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PgKCFsiXrp7t87jqeCq8WVlby5O4e1LfaZicq4pIxqqFFB856Pmygult5YWIUE+vOe
         XL+rjMs+ZyrhIlq9mU4r62Kc/WULxmbmjbH10gYboZYviro2G4qv7sqfW994tNtJJ0SX
         ylIODJdygAuG6UZ3YTLbhk0N7ilsAUuTniCfQ=
Message-ID: <49AA599B.8040308@gmail.com>
Date: Sun, 01 Mar 2009 10:47:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] loop : Don't hold the lo_ctl_mutex while fput in
 loop_clr_fd
References: <20080428021022.GB2698@darkstar.te-china.tietoenator.com>  <20080428021309.GZ5882@ZenIV.linux.org.uk>  <20080428021531.GA5882@ZenIV.linux.org.uk> <a8e1da0804271933i528d7c98m526195b361119dcf@mail.gmail.com>
In-Reply-To: <a8e1da0804271933i528d7c98m526195b361119dcf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.4.2008 04:33, Dave Young wrote:
> On Mon, Apr 28, 2008 at 10:15 AM, Al Viro<viro@zeniv.linux.org.uk>  wrote:
>> On Mon, Apr 28, 2008 at 03:13:09AM +0100, Al Viro wrote:
>>   >  On Mon, Apr 28, 2008 at 10:10:22AM +0800, Dave Young wrote:
>>   >  >  [Fixing bug 10504]
>>   >  >
>>   >  >  If the bakingfile is a block device file, losetuo -d will trigger lockdep
>>   >  >  warning of "circular locking dependency".
>>   >  >
>>   >  >  open/release lock order : bdev->bd_mutex --->  lo->lo_ctl_mutex
>>   >  >  loop_clr_fd lock order  : lo->lo_ctl_mutex --->  bdev->bd_mutex (fput)
>>   >  >
>>   >  >  Don't hold the lo_ctl_mutex while fput in loop_clr_fd to fix it. It's safe
>>   >  >  because all loop device state will be consistent here.
>>   >
>>   >  Explain.
>
> Hi, Maybe I have some mis-understood, thanks for pointing out in advance.
>
> IMO the lo_ctl_mutex is for the lo->* state locking,  they are all set
> to proper values before fput(filp), so I think it's safe to do that.
>
>>   BTW, explain also why open() at that spot will not do interesting things
>>   wrt BLKRRPART done a bit below, please.
>>
>
> open with a loop device unbound? Sorry, I don't understand.  Could you
> explain a bit? Thanks

Any ideas here? Al? The bug survived almost a year...

