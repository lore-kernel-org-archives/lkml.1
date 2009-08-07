Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZHGO0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZHGO0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbZHGO0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:26:36 -0400
Received: from mail-pz0-f195.google.com ([209.85.222.195]:59325 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbZHGO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nkeWYraSQ0L602cRomUUqJTqxwg7mH3pg9kB6lUlS2orhKByqZPGQDiEwlShixbfKM
         4ToTK9ztsus15UGsxkZa5PZfT5THX2u25bFDKVUVs+zZGsCu7rLb6dcnnvRjoNO2oL5w
         qIl3N7EAGUHcLVylhfZcwGB130ihhYVyzo7wM=
Date: Fri, 7 Aug 2009 10:26:32 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: JiSheng Zhang <jszhang3@gmail.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [UBI UBIFS] replace vmalloc with kmalloc
Message-ID: <20090807142632.GN3095@hansolo.jdub.homelinux.org>
References: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com> <4A7BF1C3.4050602@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7BF1C3.4050602@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 12:20:03PM +0300, Adrian Hunter wrote:
> JiSheng Zhang wrote:
>> If nandflash driver use DMA to support UBI and UBIFS i/o, there will
>> be panic like
>> the following. This is because UBI and UBIFS use vmalloced buffer
>> somewhere while
>> nandflash driver put the buffer under DMA and DMA support doesn't like vmalloced
>> memory.
>> [  412.369280] UBIFS: default file-system created
>> [  412.374879] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> [  412.383177] UBIFS: background thread "ubifs_bgt0_0" started, PID 887
>> [  412.389656] pgd = c0004000
>> [  412.392419] [00000000] *pgd=00000000
>> [  412.396117] Internal error: Oops: 817 [#1] PREEMPT
>>
>> Yes, I know kmalloc may fail when memory get fragmented, but I grep the UBI and
>> UBIFS's source, there are six .c files and seven .c files using
>> vmalloc, the function
>> which call vmalloc are all called during the ubi being attached and
>> the volume being
>> mounted. In embedded system, this mainly happen during kernel boot, it
>> should succeed.
>>
>> After replacing vmalloc with kmalloc, ubi and ubifs runs fine on my
>> board. I can alos upload
>> a patch.
>>
>> Comments are welcomed!
>
> vmalloc allows large (> 128KiB) buffers, but kmalloc doesn't.
> So we presently have no choice but to use vmalloc.

You could use get_free_pages to get up to 2MiB, no?

josh
