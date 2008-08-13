Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYHMItv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYHMItv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYHMIth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:49:37 -0400
Received: from saeurebad.de ([85.214.36.134]:33524 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYHMItg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:49:36 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Avi Kivity <avi@qumranet.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, LKML <linux-kernel@vger.kernel.org>,
       andrea@qumranet.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Circular vma locking with kvm, seems to be mmu notifiers related
References: <48A0D6A9.4030603@qualcomm.com> <48A29D0D.9010801@qumranet.com>
Date: Wed, 13 Aug 2008 10:49:10 +0200
In-Reply-To: <48A29D0D.9010801@qumranet.com> (Avi Kivity's message of "Wed, 13
	Aug 2008 11:36:29 +0300")
Message-ID: <87od3x9u61.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

Avi Kivity <avi@qumranet.com> writes:

> Max Krasnyansky wrote:
>> Got this on the latest mainline git.
>> There are already a couple of lockdep/kvm threads. So maybe it's known.
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 2.6.27-rc2 #36
>> ---------------------------------------------
>> qemu-system-x86/3445 is trying to acquire lock:
>>  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
>>
>> but task is already holding lock:
>>  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
>>
>>   
>
> Seems to be a false positive.  mmu_take_all_locks takes (surprise!)
> all anon_vma->locks belonging to an mm, and takes special care not to
> deadlock while doing this.
>
> We need to communicate this to lockdep somehow.

I think Peter already annotated this in
454ed842d55740160334efc9ad56cfef54ed37bc .

	Hannes
