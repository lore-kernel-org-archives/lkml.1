Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbZIPUh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbZIPUh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbZIPUhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:37:50 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:42710 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989AbZIPUht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NvJOXX09faPaC4/u/5BRTFW0yw7RzXBjUv55B01DPnQwa9hWqcGez8T2MXTAH12xNA
         NaEwBo9Eird7IA154YGIUK/3RoM0+3wsL5xl5Z4BtjbPZQSufyGQ53sCpEjvKBJ66h+M
         fl55qM+mOFbPAMLDN8PqYCBorYAtrcKx6ipdU=
MIME-Version: 1.0
In-Reply-To: <20090916202655.GA17153@merkur.ravnborg.org>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com> 
	<8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com> 
	<alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu> <20090916202655.GA17153@merkur.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 16:37:32 -0400
Message-ID: <8bd0f97a0909161337v6edbe204wfd83b4c3118b3a27@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script 
	macros.
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 16:26, Sam Ravnborg wrote:
> On Wed, Sep 16, 2009 at 11:58:01AM -0400, Tim Abbott wrote:
>> On Tue, 15 Sep 2009, Mike Frysinger wrote:
>> > the larger padding in the initramfs is kind of annoying as i cant see
>> > any need to pad it to PAGE_SIZE.  since the initramfs is released with
>> > the rest of the init section, it doesnt need whole pages.  a quick
>> > test shows that it does waste a few kb in reality.  default build for
>> > BF533-STAMP for example shows 0x1000 difference.
>> >
>> > in terms of correctness, this change misses a reference to the now
>> > deleted .init.ramfs:
>> > -       .init.ramfs :
>> > -       {
>> > -       .....
>> > -       }
>> > -
>> >        .text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))
>> >
>> > so that .text_l1 needs to updated to refer to the new section before
>> > it (.exit.data in this case).  once i make that change, the resulting
>> > link looks the same (minus the initramfs thing mentioned earlier), and
>> > it does boot.
>>
>> OK.  I guess we should plan to modify the INIT_DATA_SECTION macro to add
>> another argument specifying an alignment level for .init.ramfs.  It'd be
>> inconvenient to add that right now since there are a lot of patches in
>> linux-next or otherwise in flight that introduce uses of
>> INIT_DATA_SECTION, and those patches would all be broken by changing this
>> now.  Once the dust settles on that for this release, I'll submit a patch
>> adding said argument to INIT_DATA_SECTION.
>
> But this is all discarded during runtime so the added alignment has no cost in the end - no?

once things are booted, there should be no difference.  but
storage/boot costs increase (you have to store/extract/copy that extra
data).  you know how miserly we embedded people like to be ;).
-mike
