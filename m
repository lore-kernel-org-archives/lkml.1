Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYHBWYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYHBWYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYHBWYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:24:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:10723 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYHBWYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MTOl1wQq8XeTs1TM+paT2CElE80xxRr696OfoFTqB8M9RUXpOe4wK8+YA7Dpnlymev
         Pcq/hptUETRViMQALmn7XgJtY//dpNbFK/7gYU2pjhnG6UqeKw7oHkvsFqEnmXA2qglb
         IyfeP7AAr9OnYJxlQtx/JpQBQ89KYGPLmKxok=
Message-ID: <520f0cf10808021524j37497b0bpaf8188f77154f6d3@mail.gmail.com>
Date: Sun, 3 Aug 2008 00:24:02 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Can't boot 2.6.26-rt1
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       justinmattock@gmail.com
In-Reply-To: <alpine.DEB.1.10.0808021731010.15392@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <520f0cf10808021416n286855f9s126d416230aee249@mail.gmail.com>
	 <alpine.DEB.1.10.0808021731010.15392@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 11:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 2 Aug 2008, John Kacur wrote:
>
>> VFS: Cannot open root device
>
> Do you use an initrd boot disk? If so make sure the initrd is correct.
> Sometimes it is best to first get a 2.6.26 kernel booting without initrd
> and then use that same config on the -rt kernel.
>
> -- Steve

Thanks Justin and Steve for the hints - it turned out to be simple,
somehow the make install scripts were mangling the location of the
initrd, a quick edit to grub and everything is working again.
John

>
>> "disk/by-id/scsi-SATA_WDC_WD1600BEVS-WD-WXEZ07100576-part 7" or
>> unknown block(0,0)
>> Please append a correct "root = " boot option; here are the available
>> partitions.
>> Pid:1,comm:swapper Not tainted
>> 2.6.26-rt1-default#1linux-rt-users@vger.kernel.org
>> [< ffff ffff 8046 c149 >] rt_mutex_lock+0x22/0x50
>> [< ffff ffff 8046 cae6 >] _mutex_unlock+0xe/0x10
>> [< ffff ffff 8020 cb00 >] exit_intr+0x10/0x1e
>> [< ffff ffff 8028 633d >] trace_hardirqs_on_caller+0x1e/0x133
>> [< ffff ffff 8020 d608 >] child_rip+0xa/0x12
>> [< ffff ffff 8020 cb69 >] restore_args+0x0/0x30
>> [< ffff ffff 8020 d5fe >] child_rip+0x0/0x12
>>
>> preempt count 00000001
>> 1-level deep critical section nesting
>> [< ffff ffff 8047 43e2 >] .... panic +0x43/0x167
>> [< ffff ffff 8073 6338 >] (<= mount_block_root+0x258/0x26f
>>
>
>
