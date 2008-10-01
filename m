Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYJAHWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYJAHWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYJAHWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:22:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:12718 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJAHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NOgnOQIzeY2JdjqGRuRWgcroZ5X3jZPLHzWNrf1nV2dapsGGrfQXq+SBuQkzJyR2Is
         Rdq8KijpIw1XV9iqabYL54c7b65LtdlSPA0YinvS11qZvwQ0OJ0PgJy9/NGJ8rjobQH+
         O2yWQfl52L99s9rxh9zjm1fkJVZfCUdDALMA8=
Message-ID: <86802c440810010022x5597655dre535aa5d4b986719@mail.gmail.com>
Date: Wed, 1 Oct 2008 00:22:14 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] fix: x86: remove cpu_vendor_dev
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081001064942.GA651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
	 <20080930193736.GA4453@mailshack.com>
	 <86802c440809301337i1bbf6e9ckb8de8a1ef08955d3@mail.gmail.com>
	 <20081001064942.GA651@elte.hu>
X-Google-Sender-Auth: 25a44f294b6cc3ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 11:49 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Tue, Sep 30, 2008 at 12:37 PM, Alexander van Heukelum
>> <heukelum@mailshack.com> wrote:
>> > x86_64-kernels after commit 10a434fcb "x86: remove cpu_vendor_dev"
>> > crashed on qemu-system-x86_64 due to a typo in vmlinux_64.lds.S.
>> >
>> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
>> >
>> > ---
>> >
>> > On Tue, Sep 30, 2008 at 06:41:33PM +0200, Alexander van Heukelum wrote:
>> >> Moreover, a defconfig won't run :-/ (on qemu-system-x86_64).
>> >> Bisection pointed to commit 10a434fcb "x86: remove cpu_vendor_dev".
>> >> The kernel crashes early with a general protection fault in a call
>> >> to strnlen. I have no idea what goes wrong, yet.
>> >
>> > It took quite some time, but I found the problem... I'll leave
>> > the other one to you ;).
>> >
>> > Greetings,
>> >        Alexander
>> >
>> >  arch/x86/kernel/vmlinux_64.lds.S |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
>> > index 201e81a..46e0544 100644
>> > --- a/arch/x86/kernel/vmlinux_64.lds.S
>> > +++ b/arch/x86/kernel/vmlinux_64.lds.S
>> > @@ -172,8 +172,8 @@ SECTIONS
>> >   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
>> >        *(.x86_cpu_dev.init)
>> >   }
>> > -  SECURITY_INIT
>> >   __x86_cpu_dev_end = .;
>> > +  SECURITY_INIT
>> >
>> >   . = ALIGN(8);
>> >   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
>> >
>>
>> that is merging problem, Ingo should fix that already...
>
> indeed. I've fixed it in tip/x86/traps by applying Alexander's patch.
>

still have merging problem... in tip/master we have

  __x86_cpu_dev_start = .;
  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
        *(.x86_cpu_dev.init)
  }
  __x86_cpu_dev_end = .;
  SECURITY_INIT

  DYN_ARRAY_INIT(8)

  SECURITY_INIT

there is two copy of SECURITY_INIT

YH
