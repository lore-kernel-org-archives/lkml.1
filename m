Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZHYRRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZHYRRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbZHYRRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:17:51 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:57761 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZHYRRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HwGO4nkUvRLs4g6qxEzp1P2hbQRSjg7vtN4GLAD56/Zyk3X8GibdUZ/mPlZeTB8vlF
         0eowheJf72rJFMYWASMQ90drZDuZ52jxEWMkrumBNuWK0gH88eJLNpZgx/XdkpaJpUnP
         l0p4Q6jNrgcd5XZdgEDF296kEfZx99cFhNvGQ=
Message-ID: <4A941CBD.1040303@gmail.com>
Date: Tue, 25 Aug 2009 19:17:49 +0200
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; it; rv:1.9.1.1) Gecko/20090824 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, zdenek.kabelac@gmail.com,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk
Subject: Re: [PATCH 2/3] inotify: do not BUG on idr entries at inotify destruction
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>  <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>  <20090824173812.14196.381.stgit@paris.rdu.redhat.com>  <200908242034.50885.elendil@planet.nl>  <1251140949.25096.16.camel@dhcp231-106.rdu.redhat.com>  <alpine.LFD.2.01.0908241220590.3158@localhost.localdomain> <1251146166.25096.22.camel@dhcp231-106.rdu.redhat.com> <4A93CE2A.90509@gmail.com> <alpine.LFD.2.01.0908250931170.3218@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908250931170.3218@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 25/08/2009 18:43 Linus Torvalds wrote:
>
> On Tue, 25 Aug 2009, Mikko C. wrote:
>>
>> I just got this with -rc7, but it doesn't look related to what I was having
>> before:
>>
>> BUG: Bad page map in process kio_thumbnail  pte:ffff88006cc99128 pmd:6d3b1067
>> addr:00007f9d4e3a5000 vm_flags:08000070 anon_vma:(null)
>> mapping:ffff88007abe21a0 index:200
>> vma->vm_ops->fault: filemap_fault+0x0/0x460
>> vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x80
>> Pid: 28022, comm: kio_thumbnail Not tainted 2.6.31-rc7 #1
>> Call Trace:
>>   [<ffffffff810afaf4>] ? print_bad_pte+0x1d4/0x2c0
>>   [<ffffffff810afc79>] ? vm_normal_page+0x99/0xa0
>>   [<ffffffff810b0c7d>] ? unmap_vmas+0x4cd/0x970
>>   [<ffffffff810b6c74>] ? exit_mmap+0x104/0x1d0
>>   [<ffffffff81043e0d>] ? mmput+0x4d/0x100
>>   [<ffffffff81048d81>] ? exit_mm+0x101/0x150
>>   [<ffffffff8104b240>] ? do_exit+0x6c0/0x750
>>   [<ffffffff8104b326>] ? do_group_exit+0x56/0xd0
>>   [<ffffffff8104b3c2>] ? sys_exit_group+0x22/0x40
>>   [<ffffffff8100b7eb>] ? system_call_fastpath+0x16/0x1b
>> Disabling lock debugging due to kernel taint
>>
>> No lockups or anything.
>
> That looks like a memory corruption bug. Your page table entry is bad:
> pte:ffff88006cc99128.


Now that you mention it, I remember having a couple segfaults with a 
program I was testing earlier so I guess that could have screwed with 
memory... I'd say it's safe to ignore it unless I get another one. 
Meanwhile still no notify bug with -rc7 :)
