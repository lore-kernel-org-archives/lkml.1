Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbZIPQ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbZIPQ4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbZIPQ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:56:26 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:43347 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZIPQ4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t271b1CiXxWQOwQo7sqn9KJQgSq4HbOvlIwWhXpMen1CRpp+fBjt6m0+yIawczYaRf
         IJ5am/NCSoKcxN4NOWkixfNWtPTzgBCsjnSaOVCoKcbJQZm3xbgCHyom9y2dq9GYthHq
         cn0duvRyvPt37Ypl7napb4BsP1tzHaO7NfYLk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com> 
	<8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com> 
	<alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 12:56:08 -0400
Message-ID: <8bd0f97a0909160956m46a59e93ydd19fdbf3fb984f5@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script 
	macros.
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Bryan Wu <cooloney@kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 11:58, Tim Abbott wrote:
> On Tue, 15 Sep 2009, Mike Frysinger wrote:
>> the larger padding in the initramfs is kind of annoying as i cant see
>> any need to pad it to PAGE_SIZE.  since the initramfs is released with
>> the rest of the init section, it doesnt need whole pages.  a quick
>> test shows that it does waste a few kb in reality.  default build for
>> BF533-STAMP for example shows 0x1000 difference.
>
> OK.  I guess we should plan to modify the INIT_DATA_SECTION macro to add
> another argument specifying an alignment level for .init.ramfs.  It'd be
> inconvenient to add that right now since there are a lot of patches in
> linux-next or otherwise in flight that introduce uses of
> INIT_DATA_SECTION, and those patches would all be broken by changing this
> now.  Once the dust settles on that for this release, I'll submit a patch
> adding said argument to INIT_DATA_SECTION.

sounds good to me.  too bad the function alignment isnt specified in
arch linkage.h, otherwise i'd suggest we default to that rather than
PAGE_SIZE.  as seen in the current Blackfin linker script, we only
need the normal .text alignment of 4 bytes.
-mike
