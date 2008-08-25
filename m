Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYHYRLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYHYRLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYHYRLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:11:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:13359 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbYHYRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dRmCNJWcHLzJ3TvxVzgfxzO6yL6H0sDGykdZc5L/2IBn3RlFjTyKGlg0T98ADbSpu9
         0SnojIZymCGErlEFFaiQgAso8fWNp0HAcRLtLRD6xCeoAl1MEY1sHeJeuDcreLXHUjoY
         BsTQg9hR3CMf/E383bsFKz3qPki411qAkvwIQ=
Message-ID: <86802c440808251011k5c80a527la5066565b8cff6f5@mail.gmail.com>
Date: Mon, 25 Aug 2008 10:11:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Bernhard Walle" <bwalle@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080825141901.GE18914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080825141901.GE18914@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 7:19 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Aug 24, 2008 at 03:44:57PM -0700, Yinghai Lu wrote:
>> may need user to have new kexec tools that could create e820 table
>> from /sys/firmware/memmap instead of /proc/iomem for second kernel
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> Cc: Bernhard Walle <bwalle@suse.de>
>> Cc: Vivek Goyal <vgoyal@redhat.com>
>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> Index: linux-2.6/arch/x86/kernel/e820.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/e820.c
>> +++ linux-2.6/arch/x86/kernel/e820.c
>> @@ -1279,6 +1279,10 @@ void __init e820_reserve_resources(void)
>>
>>       res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
>>       for (i = 0; i < e820.nr_map; i++) {
>> +             if (e820.map[i].type != E820_RAM) {
>> +                     res++;
>> +                     continue;
>> +             }
>>               end = e820.map[i].addr + e820.map[i].size - 1;
>>  #ifndef CONFIG_RESOURCES_64BIT
>>               if (end > 0x100000000ULL) {
>
> I think this will wipe out ACPI related entries also from /proc/iomem
> and kdump will be broken as second kernel needs to know about the ACPI
> areas.
>
> Though, if all these entries are available in /sys/firmware/memap then
> probably one can modify kexec-tools to grep RAM entries from /proc/iomem and
> rest of the entries from /sys/firmware/memmap.

/sys/firmware/memmap have all of them. though RAM entries from
/proc/iomem could be smaller than that in /sys/firmware/memmap because
of trimming from commandline.

YH
