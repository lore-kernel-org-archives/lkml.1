Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYHZOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYHZOxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYHZOxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:53:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:64563 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYHZOxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oLzsGoRjry1qACJrf3k+PbqQV+mwqnuAn7lo0kMl4bUhG7q4CmllelArrH+ZyUF8tW
         ifC/KI38zOAEAOgzqHzZGncj2M3IQQdCTmTzpnoCBL3hoOjNAMYdBINadTFYAqWdFMgr
         kGHscBZukIgteoiM6u1qu3meK9GP+RpaSxiVw=
Message-ID: <48f7fe350808260753v132fad91g6bd2e7b36f9bbcb6@mail.gmail.com>
Date: Tue, 26 Aug 2008 10:53:03 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Cc: "james toy" <unk.nown@unix.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <48f7fe350808260715y30ef89a1le7f8abdf0be61351@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
	 <b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
	 <20080826012458.abe3bbba.akpm@linux-foundation.org>
	 <9f8af95f0808260225u162da49aj1d6f6fd9db79499f@mail.gmail.com>
	 <b647ffbd0808260302r1d50dbacr3595d160e0203ce3@mail.gmail.com>
	 <48f7fe350808260715y30ef89a1le7f8abdf0be61351@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch from james fixes one of the issues, but who ever said my
kernel was already W tainted was right. I still have this other bug
showing in dmesg:

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x4a/0x50()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc4-zenmmotm1 #8
 [<802277af>] warn_slowpath+0x6f/0xa0
 [<80579dd6>] schedule+0x256/0x6d0
 [<80361212>] idr_get_empty_slot+0xe2/0x260
 [<80361410>] ida_get_new_above+0x80/0x1c0
 [<802cd390>] sysfs_ilookup_test+0x0/0x10
 [<802cd6f1>] sysfs_find_dirent+0x21/0x30
 [<802cd7a0>] __sysfs_add_one+0x10/0x90
 [<802cd86a>] sysfs_add_one+0x4a/0x50
 [<802ce64c>] create_dir+0x4c/0xb0
 [<802ce6d9>] sysfs_create_dir+0x29/0x50
 [<80361e2f>] kobject_get+0xf/0x20
 [<80361f7d>] kobject_add_internal+0xcd/0x1c0
 [<803620fa>] kobject_set_name_vargs+0x3a/0x50
 [<80362309>] kobject_init_and_add+0x29/0x30
 [<806d235d>] kernel_param_sysfs_setup+0x5d/0xb8
 [<806d2525>] param_sysfs_init+0x16d/0x172
 [<806d23b8>] param_sysfs_init+0x0/0x172
 [<80201336>] do_one_initcall+0x26/0x170
 [<8021d87c>] activate_task+0x2c/0x50
 [<80220a00>] pre_schedule_rt+0x0/0x30
 [<80238547>] __create_workqueue_key+0x1a7/0x1f0
 [<80237c00>] worker_thread+0x0/0x100
 [<806c09bf>] kernel_init+0x170/0x251
 [<806c084f>] kernel_init+0x0/0x251
 [<80204157>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things
with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #8
 [<80361fc2>] kobject_add_internal+0x112/0x1c0
 [<80362309>] kobject_init_and_add+0x29/0x30
 [<806d235d>] kernel_param_sysfs_setup+0x5d/0xb8
 [<806d2525>] param_sysfs_init+0x16d/0x172
 [<806d23b8>] param_sysfs_init+0x0/0x172
 [<80201336>] do_one_initcall+0x26/0x170
 [<8021d87c>] activate_task+0x2c/0x50
 [<80220a00>] pre_schedule_rt+0x0/0x30
 [<80238547>] __create_workqueue_key+0x1a7/0x1f0
 [<80237c00>] worker_thread+0x0/0x100
 [<806c09bf>] kernel_init+0x170/0x251
 [<806c084f>] kernel_init+0x0/0x251
 [<80204157>] kernel_thread_helper+0x7/0x10
 =======================


On Tue, Aug 26, 2008 at 10:15 AM, Ryan Hope <rmh3093@gmail.com> wrote:
> Thanks for getting back to me on this guys.  Yes I am using mmotm, the
> daily -mm broken out tree... THe bug happens while booting, and it
> shows up many times. Anyway I checked microcode_intel.c and the
> function in question looks like this:
>
> static int __init microcode_intel_module_init(void)
> {
>       struct cpuinfo_x86 *c = &cpu_data(get_cpu());
>
>       if (c->x86_vendor == X86_VENDOR_INTEL)
>               return microcode_init(&microcode_intel_ops, THIS_MODULE);
>       else
>               return -ENODEV;
> }
>
> I will try the changes in he patch in Jame's post.... and report back. THanks.
>
> -Ryan
>
> On Tue, Aug 26, 2008 at 6:02 AM, Dmitry Adamushko
> <dmitry.adamushko@gmail.com> wrote:
>> 2008/8/26 james toy <unk.nown@unix.net>:
>>> Andrew,
>>>
>>> Yes, ours does look like this -- however when i checked the git diff on git
>>> web i found:
>>>
>>> index d2d9d74..6dd8907 100644 (file)
>>> --- a/arch/x86/kernel/microcode_intel.c
>>> +++ b/arch/x86/kernel/microcode_intel.c
>>> @@ -531,12 +531,14 @@ static struct microcode_ops microcode_intel_ops = {
>>>
>>>  static int __init microcode_intel_module_init(void)
>>>  {
>>> -       struct cpuinfo_x86 *c = &cpu_data(get_cpu());
>>> +       struct cpuinfo_x86 *c = &cpu_data(0);
>>
>> (err... I'm a bit confused by the use of "fixed" here. The snippet
>> posted by Andrew illustrates how it was _before_ the fix,
>> i.e. it's the version that causes the "scheduling while atomic" bug).
>>
>> IOW, If your local version has cpu_data(get_cpu()) in
>> microcode_intel_module_init(), then it explains the trace you have
>> observed. That also means you are not up-to-date with -next.
>>
>>
>> --
>> Best regards,
>> Dmitry Adamushko
>>
>
