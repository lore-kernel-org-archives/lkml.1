Return-Path: <linux-kernel-owner+w=401wt.eu-S934842AbZAOVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbZAOVEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbZAOUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:35:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49574 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360AbZAOUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cZz0hBBQqH4Z+YhPDau5dfeoSdJPjgoE8ovo8yH4tlW3dfimVZTCnY8zc9L4ySAKQN
         FXNNfWowVkd1qO8/P8LhfD7BMhRQuuViZj8SnT3JjECH1lic8Eem1wzCBy9UX0orUWD2
         AtRt5eEenWUeiWnNFRIHsClx2ytaZBjIWY9Kk=
Message-ID: <baeb34bc0901151235v3c19306enaa2b6b11a18e1275@mail.gmail.com>
Date: Thu, 15 Jan 2009 15:35:02 -0500
From: "James Kirin" <james.kirin40@gmail.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
Cc: "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org
In-Reply-To: <baeb34bc0901151150w4ad88du78d91f6db50983e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
	 <adaeiz6k4o4.fsf@cisco.com>
	 <baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>
	 <86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com>
	 <baeb34bc0901151150w4ad88du78d91f6db50983e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried disabing CONFIG_MTRR_SANITIZER and CONFIG_X86_PAT in the
kernel, and now a different kernel panic occurs:

[... ] Write protecting the kernel text: 3040k
[...] Write protecting the kernel read-only data: 1352k
[... ] khelper used greatest stack depth: 6724 bytes left
[ ...] Kernel panic - not syncing: No init found. Try passing init=
option to kernel.

Is an "init=" option necessary when using disable_mtrr_trim?

Thanks in advance,

James

On Thu, Jan 15, 2009 at 2:50 PM, James Kirin <james.kirin40@gmail.com> wrote:
> Hi Yinghai,
>
>> please do
>> 1. boot linux with "disable_mtrr_trim" in grub.conf etc
>> 2. after booting input:
>> echo "base=0x100000000 size=0x20000000 type=write-back" >/proc/mtrr
>
> Thank you for your suggestion.
>
> Unfortunately, booting with disable_mtrr_trim leads to a kernel panic:
>
> [<c0103abb>] kernel_thread_helper+0x7/0x1c
> ===========
> Code: 0c 31 d2 89 e8 e8 c2 f4 ff ff 89 c3 eb 8e 8b 85 cc 00 00 00 89 44 24 10 83
> bd ec 00 01 00 04 0f 84 cf 00 00 00 8b 9d f0 00 01 00 <8b> 43 10 3b 43 0c 0f 84
> d5 00 00 00 8b 53 10 8b 85 ec 00 01 00
> EIP: [<c026bc2f] hid_parser_main+0xcf/0x290 SS:ESP 0068:f7c2bd7c
> ---[ end trace 34615b445589fbb6 ]---
> Kernel panic - not syncing: Attempted to kill init!
>
> I am attaching the kernel config file. The system boots fine if I
> remove "disable_mtrr_trim" from lilo.conf (and rerun lilo).
>
> Thank you for any help,
>
> James
>
