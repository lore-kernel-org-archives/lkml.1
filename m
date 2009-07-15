Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZGOLTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZGOLTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZGOLTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:19:02 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:60033 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZGOLTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WNuLtL4Cuq3Xi3jt/64SocemM74gB9dvlFY8756Ns/Q+soz+Zm4ocAvKbkwfyaA7PJ
         gIQPpzfz3+laCSWgag8gLbua7QJrAlyZPq+Yo3irwPXnxMhXe2qVLDQ3pFcUghW1s6xC
         et1HDK/bD9Jfl03wawuCxQwHiurlNJC62Y5Hs=
MIME-Version: 1.0
In-Reply-To: <12331.1247653900@redhat.com>
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> 
	<20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com> 
	<4A5CFFD8.7020106@t-online.de> <12331.1247653900@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jul 2009 07:18:40 -0400
Message-ID: <8bd0f97a0907150418x5190c8e2o31bee10533478372@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] NOMMU: add support for Memory 
	Protection Units (MPU)
To: David Howells <dhowells@redhat.com>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 06:31, David Howells wrote:
> Bernd Schmidt wrote:
>> No page table, just three bitmaps (r/w/x), with one bit per page, per mm.
>
> That sounds a bit inefficient as you have to make three accesses per page.  I
> suppose it depends on how your MPU works.

there isnt any hardware assistance in terms of speeding up misses.
they're treated like any other hardware exception.  it does
differentiate between inst and data misses though, so the software
replacement algorithm doesnt have to check all three.

the code for handling CPLB (effectively the same thing as a TLB for
this discussion) is contained in
arch/blackfin/kernel/cplb-mpu/cplbmgr.c.  it's a pretty small file --
the entry point is cplb_hdr() and that calls the relevant function to
handle inst or data misses.
-mike
