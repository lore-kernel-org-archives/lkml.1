Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYCNQI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYCNQI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCNQIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:08:17 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:54255 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYCNQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oML/qknliR+0/yW/E+mmoC4QuaYYfU+kR4Rbl/y7r0Qrf09hPkdzJBV1/lcXy+qHkZ1LJUVaswlplqLFWQ+I4VnjYDzIudTXFGNIYcYVLTLAJvyEeiRboiOSOGhOuQQUSnjTQm+3G2VvliuWqTCzftJ+meGRGuLjfARUBROWZTA=
Message-ID: <54b90fdf0803140908k44bee3a2gbf4187ae40dad4b3@mail.gmail.com>
Date: Fri, 14 Mar 2008 12:08:16 -0400
From: Yan <rottled@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: 2.6.22.6 - Discrepancy between running and on-disk kernels
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080314090049.346d7428@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54b90fdf0803140751m71935a09r9b039ca6eb124f4d@mail.gmail.com>
	 <20080314090049.346d7428@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you point me to where in the source that self-patching happens? I
tried grep'ing
through the source for anything relevant, and came out empty handed.

-yan

On Fri, Mar 14, 2008 at 12:00 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 14 Mar 2008 10:51:43 -0400
>  Yan <rottled@gmail.com> wrote:
>
>  > Hello,
>  >
>  > I have been trying to compare the code from the on-disk compressed
>  > kernel that was booted and the running kernel extracted
>  > from /dev/kmem. I extracted the kernel's code from the disk image by
>  > stripping the head.S and similar and gunzipping it, and extracted the
>  > kernel from /dev/kmem by reading data between _text and _etext symbol
>  > offsets.
>  >
>  > I then ran both through a disassembler and diff'ed the outputs.
>  > Predictably, the disassembly was similar, but not identical. Some
>  > instructions (e.g. bts) had a 'lock' prefix, where as others had a
>  > 'nop' in its place.
>  >
>  > There were other differences with some instructions like mfence.
>  > Everything else matched just fine, the differences were mostly in
>  > memory-referencing instructions.
>  >
>  > My question is, what can be changing the kernel between being on
>  > static storage and being loaded?
>
>  the kernel code is self-patching, it gets modified to match your system
>  during boot time. So you cannot assume that the kernel on disk and the kernel
>  in memory are identical.
>  (Same goes for modules)
>
