Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbZAQEQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbZAQEQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 23:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZAQEQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 23:16:20 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:52251 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZAQEQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 23:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DPm/nR+7b644kgzNvZY09MJSSTXyHf/VVuAuEgcNkPge4Cb95yFtsPHlufZTWp15F4
         Nhaif0ybAvi+Iqib9f6FHdVi3TF1WSAifrq0wJxXZbu2sVKmMYoQFh95lZ0tx+mPOhFp
         H0uJArPfnDlreMU9WmLs039CCQ38Hh7rWHQeI=
MIME-Version: 1.0
In-Reply-To: <21512362.post@talk.nabble.com>
References: <21512362.post@talk.nabble.com>
Date: Fri, 16 Jan 2009 23:16:08 -0500
Message-ID: <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com>
Subject: Re: Kernel vs user memory
From: Bryan Donlan <bdonlan@gmail.com>
To: sidc7 <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 9:56 PM, sidc7 <siddhartha.chhabra@gmail.com> wrote:
>
> The kernel maintains a free list of pages that are free in physical memory. I
> was wondering, are these pages in the kernel space ? They are not mapped to
> any of the user address space for sure, so will they be in the kernel memory
> ?

Of course. Note that much of user address space is also mapped into
kernel address space (all of it, in fact, unless you're on a 32-bit
x86 system with PAE and more than 3G or so of RAM), so such a clear
division isn't quite that easy :)

All the gory details are in mm/page_alloc.c and mm/slab.c (or slub.c
or slob.c, depending on your build configuration).
