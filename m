Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYFYQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYFYQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYFYQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:58:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:59876 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYFYQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mapEYqE3qNbUh4/xQTPj8PaRJOnij1lqw9mZOTSg1Y4vl7UFf6+37WJPmURAfkB4bx
         tcqswKPH7ADBRD1VwemcTadX5DMKVjuDgA4eIJ9dW7eIOJ1RqOiFf/l+3lS8/4t7EIo7
         nDc6PHEwKSwbujrgowrM8Lucow6KYtq1ut8AY=
Message-ID: <86802c440806250958j691988c4q19278400dadf7e15@mail.gmail.com>
Date: Wed, 25 Jun 2008 09:58:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       kexec@lists.infradead.org
In-Reply-To: <20080625180319.122819ea@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214395342-20375-1-git-send-email-bwalle@suse.de>
	 <1214395342-20375-4-git-send-email-bwalle@suse.de>
	 <86802c440806250901n68278ab1ma1add38c165122af@mail.gmail.com>
	 <20080625180319.122819ea@halley.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 9:03 AM, Bernhard Walle <bwalle@suse.de> wrote:
> * Yinghai Lu [2008-06-25 09:01]:
>> On Wed, Jun 25, 2008 at 5:02 AM, Bernhard Walle <bwalle@suse.de> wrote:
>> >  }
>> >  early_param("mem", parse_memopt);
>> > @@ -1023,6 +1025,7 @@ static int __init parse_memmap_opt(char *p)
>> >                e820_add_region(start_at, mem_size, E820_RESERVED);
>> >        } else {
>> >                end_user_pfn = (mem_size >> PAGE_SHIFT);
>> > +               e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
>> >        }
>> >        return *p == '\0' ? 0 : -EINVAL;
>> >  }
>> > --
>>
>> only this one is needed now. but please change ULLONG_MAX to
>> ULLONG_MAX - mem_size
>
> Why can't we add that check at the beginning of e820_update_range() as
> you suggested?
that patch about fixing e820_update_rang is in tip/setup-memory.

so the one is supposed to be ok, but it is good to keep good input
parameter too.

YH
