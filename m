Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbZARGX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbZARGX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 01:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZARGXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 01:23:48 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:44016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZARGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 01:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jv3qLRBIDVjHcAiV1He58DTl8afQAqali7/tlsfQTDu2CnhryijGRuWxnkkacrHnWC
         HlgURTuklgS5j9b5/4SudZaVNGdKpgT9RVfjWB19QOnFQ4f9lyG5v47W4odCzTF/B2R2
         t5hsr2Tlv1vY/p+XK1Y22aKAU1QBmYNjWMnYc=
MIME-Version: 1.0
In-Reply-To: <200901170328.15178.rob@landley.net>
References: <20090115194033.GA10926@hack.private>
	 <20090116124158.4364e269.akpm@linux-foundation.org>
	 <200901170328.15178.rob@landley.net>
Date: Sun, 18 Jan 2009 14:23:46 +0800
Message-ID: <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
From: Daolong Wang <ahlongxp@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       jdike@addtoit.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm this link error. And this patch works for me.

On Sat, Jan 17, 2009 at 5:28 PM, Rob Landley <rob@landley.net> wrote:
> On Friday 16 January 2009 14:41:58 Andrew Morton wrote:
>> > diff --git a/arch/um/sys-i386/sys_call_table.S
>> > b/arch/um/sys-i386/sys_call_table.S index 00e5f52..04147dc 100644
>> > --- a/arch/um/sys-i386/sys_call_table.S
>> > +++ b/arch/um/sys-i386/sys_call_table.S
>> > @@ -6,6 +6,7 @@
>> >
>> >  #define sys_vm86old sys_ni_syscall
>> >  #define sys_vm86 sys_ni_syscall
>> > +#define sys_sigprocmask sigprocmask
>> >
>> >  #define old_mmap old_mmap_i386
>>
>> For how long has this problem been present?
>>
>> Why aren't lots of other people reporting it?
>
> I'm not sure User Mode Linux still has a lot of users regularly testing the
> latest and greatest version.  (QEMU and KVM kinda took the wind out of its
> sails.)
>
> I still find it useful to be able to stick printfs into the code and debug
> stuff even when the console isn't working, but I haven't been able to build a
> version of 2.6.28 that works for me at all:
>
> cat > mini.conf << EOF
> CONFIG_BINFMT_ELF=y
> CONFIG_HOSTFS=y
> CONFIG_LBD=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_STDERR_CONSOLE=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT3_FS=y
> CONFIG_STATIC_LINK=y
> CONFIG_NO_HZ=y
> CONFIG_UNEVICTABLE_LRU=y
> EOF
> make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf
> make ARCH=um -j 3
> ./linux rw init=/bin/bash rootfstype=hostfs
>
> The result panics (twice) and exits, instead of giving me a shell prompt.
> Built and run on stock Ubuntu 8.10.  (I posted about it on tuesday, but nobody
> replied...)
>
> Rob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
