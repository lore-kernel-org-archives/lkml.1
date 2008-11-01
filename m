Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYKAI4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYKAI4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 04:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYKAI4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 04:56:24 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:39261 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYKAI4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 04:56:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=JTEK3FhkX4HePp5Cc/6Dlr4x4k6kiE/F5iaViLazU7rehZuWrQ4yHxj63QAFT8WGk/SFKK0UaASp2MA+57mnTMVm9GjeXkKZfVcyUnA5fp1AaHMIYg9xJIE5uW1TlA3o;
Message-ID: <490C19A1.3070805@simon.arlott.org.uk>
Date: Sat, 01 Nov 2008 08:56:01 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080928)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: ext3 __log_wait_for_space: no transactions
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081031235459.055c35d7.akpm@linux-foundation.org>
In-Reply-To: <20081031235459.055c35d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/08 06:54, Andrew Morton wrote:
> On Thu, 30 Oct 2008 11:49:34 +0200 (EET) Meelis Roos <mroos@linux.ee> wrote:
> 
>> I get this problem nightly on 2.6.28-rc2-* kernels on a generic
>> Celeron 900/Intel 815/PATA/ext3 system.
>> 
>> __log_wait_for_space: no transactions
>> Aborting journal on device sda3.
>> ext3_abort called.
>> EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
>> Remounting filesystem read-only

I had the same problem overnight:
[189366.094152] __log_wait_for_space: no transactions
[189366.094162] Aborting journal on device dm-0.
[189366.094176] ext3_abort called.
[189366.094180] EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected aborted journal
[189366.094185] Remounting filesystem read-only

It's ext3 on LVM2 on MD RAID1 and I already had a 128MB journal:
dumpe2fs 1.41.3 (12-Oct-2008)
Journal inode:            8
Journal backup:           inode blocks
Journal size:             128M

2.6.28-rc2 753dcfeecc0e293dbe6f3d59643741af9e610f4f

> 
> ug.  Was 2.6.27 OK?

Yes. Nothing new was running at that time (and most of what was running was 
using other filesystems) so I don't know I can reproduce this.

There's some bizzare corruption in /var/log/messages several hours before:
Oct 31 22:10:08 redrum [170202.741590] ehci_hcd 0000:00:02.1: devpath 1.1.2 ep1in 3strikes
Oct 31 22:10:08 redrum [17022710]ub1112 nikq100/ff80f070sat0[/ s
Oct 31 22:10:08 redrum 7[722715]ec_c 000:21 esdq ff80f070shdl
Oct 31 22:10:08 redrum 7[722716]ub1112 ikq100/ff80f070sat0[/ s
Oct 31 22:10:08 redrum 7[722717]ub1112 nikq100/ff80f070sat0[/ s

Oct 31 22:10:44 redrum 4<>103.631 d1::::[d]Atce CIrmvbeds
Oct 31 22:10:44 redrum 7[728900]P:Adn nofrN u:3000<7>[170238.964799] PM: Adding info for No Bus:sdf

Oct 31 22:10:45 redrum 7[729113]P:Adn nofrN u:sdv.4e0
Oct 31 22:10:45 redrum 6[729115]ub1112 e S eiefud dedr06,iPoutc4
Oct 31 22:10:45 redrum 6[729115]ub1112 e S eiesrns f=,Pout2 eilubr0<>103.199 s -..:Pout S-S2OtclMue<>103.192 s -..:Mnfcue:Lgtc
Oct 31 22:10:45 redrum 7[729116]hb11110 tt  ot  h 00et00

These were ok in the kernel log buffer.


On 31/10/08 14:07, Theodore Tso wrote:
>> > How big is your journal?   What does this report?
>
> You'll almost certainly get much better performance if you increase
> your journal size.  I[t] should make the crash go away, too, although I
> would like to figure out what is going on so we can fix it.

Why should a crash with a small journal be expected?

-- 
Simon Arlott

