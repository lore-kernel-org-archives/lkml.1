Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZKCPOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZKCPOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZKCPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:14:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36428 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZKCPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Asl92AKFOagwyr+jV4w6qkzTdcAiAK2vTrbBp3UfCHEwKS4JiiJokr552ciHS9O3Ni
         w4+hXoSY2p7zA0ZG/nMERwffN0h9O3uQHzHyqBljgv1DOV4JdxH/NnHcXrmqBCokd47s
         bOwLbOmpKJXlKleHidBEarcUP2t11jO97f9aQ=
Message-ID: <4AF048D1.4090402@gmail.com>
Date: Tue, 03 Nov 2009 16:14:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, hbabu@us.ibm.com,
       kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: kdump fails to load and crashes [was: mmotm 2009-11-01-10-01
 uploaded]
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org> <4AEF673E.5030509@gmail.com> <20091103144450.GB4235@redhat.com>
In-Reply-To: <20091103144450.GB4235@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2009 03:44 PM, Vivek Goyal wrote:
> On Tue, Nov 03, 2009 at 12:11:58AM +0100, Jiri Slaby wrote:
>> On 11/01/2009 07:07 PM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
>>
>> Hi, kdump loading crashes:
>> BUG: unable to handle kernel paging request at ffff8800010a7000
>> IP: [<ffffffff8101cd8b>] machine_kexec_prepare+0x16b/0x13e0
>> PGD 1806063 PUD 180a063 PMD 10001e1
...
>> ffff8800010a7000 should be OK, as crashkernel=64M@16M was passed to the
>> kernel.
>>
> 
> This is strange. As you said, ffff8800010a7000, should be a valid address
> as you reserved memory from 16M.

Hmm, PMD has not RW bit set and we do store (see below).

> I took above -mm and for me kernel loads fine. I reserved memory 64M@32M
> as by default kernel is loading at address 16M.
> 
> How does your /proc/iomem look like in first kernel?

I'm not any longer on that machine. init_pgtable() overwrites random
memory, so possibly even host's page tables, hence the oops above, I
suppose.

I'm currently chasing it down in the qemu virtual machine, since I
already got a garbage into my ~/.viminfo (some overwritten page got
flushed, I guess).

There /proc/iomem looks like:
00100000-12beffff : System RAM
  01000000-04ffffff : Crash kernel
    01000000-014680c2 : Kernel code
    014680c3-016f39f7 : Kernel data
    0175b000-017d97ab : Kernel bss

I'll keep you informed.
