Return-Path: <linux-kernel-owner+w=401wt.eu-S934991AbZLGKKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991AbZLGKKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934963AbZLGKKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:10:10 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:50986 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934942AbZLGKKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OhdQ1+omjTPcHCC6c5rBplqOqZGDBe2zua57JXQsfDx8Noi/2Ub4WR8W3NpaqV7m3P
         UIbVhFC5BhW11M6F/C5zmLuYXLh3iVICeAH8hHQeJxYwWdKSEcgE0YGrG7rldPhbnx7F
         4s1x9tQqoq30ZTcTYuJ1GaZHX6llBmxPIzSyk=
MIME-Version: 1.0
In-Reply-To: <643.1260026074@redhat.com>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 
	<14959.1259948697@redhat.com> <4B19A92A.5030804@analog.com> 
	<643.1260026074@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 7 Dec 2009 05:09:55 -0500
Message-ID: <8bd0f97a0912070209k5c87643cm53a24566f7e63a9f@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize 
	program header parsing
To: David Howells <dhowells@redhat.com>
Cc: Jie Zhang <jie.zhang@analog.com>,
       uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 10:14, David Howells wrote:
> Jie Zhang <jie.zhang@analog.com> wrote:
>> > There needs to be a mapping covering the SRAM region for the purposes of the
>>
>> Our GDB is still lack of the feature to debug applications using SRAM. So this
>> part of code was not got exercised. So if we remove this line, can this patch
>> got merged?
>
> No.  Firstly, the piece of storage that gets munmapped isn't used, so unmapping
> it isn't wrong.  What you need to do is to put a mapping over the bit of the
> SRAM you wish to use and then fill it and use it.  Ideally, you'd do this
> inside of do_mmap_pgoff() - that way those bits of the SRAM can be shared, but
> I'm not sure how best to do that.

we've looked into trying to represent the SRAM regions with normal
VMA's a few times, but i think the conclusion every time has been that
it isnt [currently] doable.  i vaguely recall it's due to the fact
that Blackfin SRAM is harvard based and VMA's cant cope with this
restriction.  Sonic should be able to provide more details though.

currently we have a simpler allocator for kernel/user space to
leverage so that small pieces can be dynamically allocated/freed.

> But you need to stick a VMA over it so that various checks don't spit
> EFAULT/EIO at you.

we give SRAM's a "pass" in every place where addresses are checked
-mike
