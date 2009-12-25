Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZLYP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZLYP27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 10:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZLYP26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 10:28:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55022 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZLYP25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 10:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e6F/J48bItfu/8MhPnf529Az82LQinlq3WgRW6ZrSOKGT4V4I5AeuvgKEYiBpHtV91
         BhCHgWudMjBNT6wjQ/fDjJYAA3M3NjjVCZY6ct+fFH9dbF3ZWVd5xrDRUBjipmcczoWq
         11Vfy+8cesQdw04lnmQzbZ4t9jZTQrHgDc+OY=
MIME-Version: 1.0
In-Reply-To: <2d0a357f0912250432l4c407696g5ff7c35d5721a2ae@mail.gmail.com>
References: <2d0a357f0912241711o97011od6c1750d7acf8b9e@mail.gmail.com>
	 <4B3413C4.6070602@gmail.com>
	 <2d0a357f0912250048h2bc987ccs4d4d253a4155becf@mail.gmail.com>
	 <2d0a357f0912250315r1f3922e1ta731d03a313d69c6@mail.gmail.com>
	 <2d0a357f0912250432l4c407696g5ff7c35d5721a2ae@mail.gmail.com>
Date: Fri, 25 Dec 2009 16:28:54 +0100
Message-ID: <8db1092f0912250728w2e97c92fp139837fdacbcf698@mail.gmail.com>
Subject: Re: [2.6.33-rc2] ACPI problems on HP nc6400 notebook
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       len.brown@intel.com, w.landgraf@ru.ru,
       "Justin P. Mattock" <justinmattock@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/25 Sedat Dilek <sedat.dilek@googlemail.com>:
> While dell-wmi and hp-wmi is concerned I only applied this patch (see
> file attachment):
>
>    0001-Revert-wmi-Free-the-allocated-acpi-objects-through-w.patch
>
> This fixes ACPI/WMI problems onmy HP nc6400 notebook.
>
> ----- Please REVERT the following commit in 2.6.33-rc2 -----
>
> commit 3e9b988e4edf065d39c1343937f717319b1c1065
> Refs: v2.6.33-rc1-10-g3e9b988
> Author:     Anisse Astier <anisse@astier.eu>
> AuthorDate: Fri Dec 4 10:10:09 2009 +0100
> Commit:     Len Brown <len.brown@intel.com>
> CommitDate: Thu Dec 24 00:42:00 2009 -0500
>
>    wmi: Free the allocated acpi objects through wmi_get_event_data
>
>    These function allocate an acpi object by calling wmi_get_event_data, which
>    then calls acpi_evaluate_object, and it is not freed afterwards.
>
>    And kernel doc is fixed for parameters of wmi_get_event_data.
>
>    Signed-off-by: Anisse Astier <anisse@astier.eu>
>    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
>    Signed-off-by: Len Brown <len.brown@intel.com>

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

> [...]
>
> - Sedat -
>
> On Fri, Dec 25, 2009 at 12:15 PM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> [CCed linux-acpi ML, maciej.rutecki@gmail.com and landgraf@ru.ru]
>> (see [2] and [3])
>>
>> GOTCHA!
>>
>> I reverted patches introduced in:
>>
>> commit 2969cd482ebe9c5b82d55917b0cd41175eff042a:
>> "Merge branch 'misc-2.6.33' into release"
>>
>> ...and now I could boot into 2.6.33-rc2.
>>
>> Here the revert-acpi-patches:
>>
>> $ ls debian/patches/revert-acpi-patches/
>> 0001-Revert-hp-wmi-Fix-two-memleaks.patch
>> 0002-Revert-acer-wmi-msi-wmi-Remove-needless-DMI-MODULE_A.patch
>> 0003-Revert-dell-wmi-do-not-keep-driver-loaded-on-unsuppo.patch
>> 0004-Revert-wmi-Free-the-allocated-acpi-objects-through-w.patch
>> 0005-Revert-drivers-platform-x86-acerhdf.c-check-BIOS-inf.patch
>> 0006-Revert-acerhdf-add-new-BIOS-versions.patch
>> 0007-Revert-acerhdf-limit-modalias-matching-to-supported.patch
>> 0008-Revert-toshiba_acpi-convert-to-seq_file.patch
>> 0009-Revert-asus_acpi-convert-to-seq_file.patch
>> 0010-Revert-ACPI-do-not-select-ACPI_DOCK-from-ATA_ACPI.patch
>> 0011-Revert-MAINTAINERS-add-maintainer-for-msi-wmi-driver.patch
>> 0012-Revert-fujitu-laptop-fix-tests-of-acpi_evaluate_inte.patch
>> 0013-Revert-arch-x86-kernel-cpu-cpufreq-acpi-cpufreq.c-av.patch
>>
>> In [1] you can find revert-acpi-patchset, dmesg & lspci outputs of my
>> new kernel.
>>
>> Marciej and Werner can you please verify or dig deeper by partially
>> excluding the single reverts?
>> Thank you.


Patch solves the problem.


Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
