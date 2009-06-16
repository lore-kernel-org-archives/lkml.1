Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZFPP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZFPP3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZFPP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:29:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:20660 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZFPP3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CEq6yvtBsdimwlejpWAuocrVkJx27GxvKD4EwG66Xc7XU+59stvvVm2zaW1b8slUJu
         1CcsTLUYU/na1kAJHJwvfczFkHzxL7rhyctXfwnMCOBNo/1b4PPK8/JGEbhXTuRaN4jN
         R2xAL51AYy/ZmyuTSAhMycR+OvOcM5frgjcb8=
MIME-Version: 1.0
In-Reply-To: <m17hzdhkr8.fsf@fess.ebiederm.org>
References: <4A2A7F33.4030807@oracle.com> <4A2CA96D.3090502@oracle.com>
	 <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	 <4A2CC52B.9010602@oracle.com>
	 <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
	 <m1ab4i11zx.fsf@fess.ebiederm.org>
	 <20090611050929.GA2706@cr0.nay.redhat.com>
	 <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
	 <m17hzdhkr8.fsf@fess.ebiederm.org>
Date: Tue, 16 Jun 2009 23:29:18 +0800
Message-ID: <2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 6:08 PM, Eric W. Biederman<ebiederm@xmission.com> wrote:
> Amerigo Wang <xiyou.wangcong@gmail.com> writes:
>
>> Fix wrong /proc/kcore size on x86_64.
>>
>> x86_64 uses __va() macro to caculate the virtual address passed to kclist_add()
>> but decodes it with its own macro kc_vadd_to_offset(). This is wrong.
>
> Ok.  I finally understand what is going on here, and no kc_vaddr_to_offset
> is not wrong when applied to a virtual address.  In fact I expect the current
> definition makes things a bit more predictable.
>
> And yes kclist_add is must be given a virtual address
>
>> Also, according to Documentation/x86/x86_64/mm.txt, kc_vaddr_to_offset()
>> is wrong too.
>
> How so?  The file offset is a number space that is different from both
> physical and virtual addresses.

Why? They _do_ have some calculated relations.

>
>> So just remove them, use the generic macro.
>
> I think a case can be made either way.  In practice neither answer
> gives us a dense offset space on x86_64 so I think I prefer the
> current definition which sets or clears the high bits as opposed
> to something that mangles the address more.
>

I am trying to dig more... There must be something wrong there.

>
> It uses get_kcore_size and (size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
> The second definition being bogus as it has nothing to do with which
> offsets are accepted.

Agreed. Maybe we can just remove the second one and update the doc?
