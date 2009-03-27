Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZC0Ffe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZC0Ffe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZC0FfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:35:21 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:45477 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZC0FfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c/kq7znEXe5pIuYGa7XFctWFhZCDdmFQOHpHfGnYS7vIqz9nMPDbBiCsqAMTPVttoE
         iLiHpDnjIwFWjH+J/UDpaan654Vrq2hsVhEy5GDLnfZ1Y/xAfHsqftEogyC6Afx2qfhA
         T2YQE9G93eZdnkeJB4Z1C3rliJdQZTvuPqpQI=
MIME-Version: 1.0
In-Reply-To: <22736146.post@talk.nabble.com>
References: <22736146.post@talk.nabble.com>
Date: Fri, 27 Mar 2009 01:35:18 -0400
Message-ID: <3e8340490903262235g6174c6b4t4bfd76311be91eeb@mail.gmail.com>
Subject: Re: Copy-on-write
From: Bryan Donlan <bdonlan@gmail.com>
To: sidc7 <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 1:15 AM, sidc7 <siddhartha.chhabra@gmail.com> wrote:
>
> When the kernel does a COW, say from a "src" to a "dest" page, does it need
> to map the "src" and "dest" page to its address space or the kernel can
> directly initiate the read from "src" and write to "dest" page ?

If the source and destination pages are not in high memory (exactly
where this boundary is depends on your architecture) they do not need
to be mapped before copying. See cow_user_page in mm/memory.c,
copy_user_highpage in include/linux/highmem.h and kmap_atomic in
arch/x86/mm/highmem_32.c (as well as implementations for other
architectures)

Note that on 64-bit platforms, generally there will be no high memory,
and so remappings will never be needed to carry out a COW.
