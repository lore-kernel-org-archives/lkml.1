Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZIPDNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZIPDNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZIPDNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:13:33 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:38459 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZIPDNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=irXXesYaaJymlaWoMHIu/tlGEz5qlK3VuwaRnvo1LQERwxpQzMF4M7iFlDZTIdl2aa
         C6fPtFA3OgbizuiyGxDU9cmU0iGUKnJ/cCoi0wsIOR3gTc4MGQ8huoJyWz04POTOLxUW
         O2kR/VYVuVWooW7/Jf4XjWTPVVXQ1Kz0d8Iuc=
MIME-Version: 1.0
In-Reply-To: <1252292753-11792-1-git-send-email-tabbott@ksplice.com>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 23:13:16 -0400
Message-ID: <8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script 
	macros.
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Bryan Wu <cooloney@kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the larger padding in the initramfs is kind of annoying as i cant see
any need to pad it to PAGE_SIZE.  since the initramfs is released with
the rest of the init section, it doesnt need whole pages.  a quick
test shows that it does waste a few kb in reality.  default build for
BF533-STAMP for example shows 0x1000 difference.

in terms of correctness, this change misses a reference to the now
deleted .init.ramfs:
-       .init.ramfs :
-       {
-       .....
-       }
-
       .text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))

so that .text_l1 needs to updated to refer to the new section before
it (.exit.data in this case).  once i make that change, the resulting
link looks the same (minus the initramfs thing mentioned earlier), and
it does boot.
-mike
