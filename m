Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZLBVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZLBVk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZLBVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:40:29 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39622 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZLBVk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:40:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cuhCGATY+Lasxis7BkBNI/I/gmKCIMQcgKYNxyTaA2ze/3DzNCcwwv7xoAYSOxocoU
         fTqzoucDUhrUnYjEXGsePIMYrHAhIrTBlngj8IJeGYRs9ZqP950koHAVa8TWYpp2ohwj
         OE/gUF9yoBqrhp2TZL6V3pn6u0XoVTwksFY2M=
MIME-Version: 1.0
In-Reply-To: <15859.1259763330@redhat.com>
References: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com> 
	<15859.1259763330@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 2 Dec 2009 16:40:15 -0500
Message-ID: <8bd0f97a0912021340l47b861a6l8444f8246581375@mail.gmail.com>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
To: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 09:15, David Howells wrote:
> Mike Frysinger wrote:
>> (yes, this now does the icache flush while holding the
>> nommu_region_sem, but i'm interested if the _idea_ is OK)
>
> Yes...  But it's not quite as simple as you think.  The first mapping made of
> a file could be PROT_READ only, in which case a second, executable mapping
> made that shares it would not get flushed from the icache.

that is a tricky edge case ;)

> How about the attached patch?

it works, but i think we want to put the vm_icache_flushed in
linux/mm_types.h behind NOMMU so we dont bloat the MMU guys ?
-mike
