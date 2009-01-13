Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbZAMO0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbZAMO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZAMO0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:26:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:32865 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbZAMO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:26:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZmA/gko/iTzfbcgfzXcnBybUj2UDkeFZ/Qh7z/DGpUMMm1iIuyNEbi7RdFFNjIWGXr
         o0KhpkyRfm7kWLzRxAYkPGjUw/qTzPQDPXDJZ9IRu18/UxSfNmn4NeFk4IebhWiceJTT
         QCQcgxRX6HqNDkvXjRESSoSQkZEHZP7vmOT7Q=
Message-ID: <73c1f2160901130626w5b808968vbc821bbf3f284424@mail.gmail.com>
Date: Tue, 13 Jan 2009 09:26:38 -0500
From: "Brian Gerst" <brgerst@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based on SMP
Cc: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
In-Reply-To: <496C9FB7.9050907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
	 <496C717F.70204@kernel.org>
	 <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
	 <496C9FB7.9050907@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 9:05 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Brian.
>
> Brian Gerst wrote:
>> I've been working on a patchset that does something similar, but
>> eliminating the PDA completely.  The start is already in tip/x86/pda.
>> The plan is to change all PDA variables to be normal per-cpu
>> variables, merging with 32-bit where possible.
>
> I think the two changes aren't exclusive at all.  The order of things
> could be different but in the end, yeah, zero-based percpu symbols w/
> mostly empty pda is the goal.
>
>> Once the PDA is empty, I'll base %gs at the start of the per-cpu
>> area.  I've been working out the bugs with the last patch
>> (zero-basing the percpu area) before submitting, but I probably
>> won't have the time until this weekend to polish it off.  I could
>> submit all but the last patch if you'd like.
>
> Any chance you can rebase those patches on top of mine?  If you don't
> have time, just send them to me, I'll try to integrate them this week.

Are your patches available via git by chance?

>> They are functionally correct, but because the per-cpu area isn't
>> zero-based yet the generated code is a bit bloated due to having to
>> calculate the delta for the %gs offset.
>
> BTW, what did you do about the dreaded stack_canary?

I put the irqstack at the start of the per-cpu area and overlaid the
canary on the bottom 48 bytes of the 16k stack.

--
Brian Gerst
