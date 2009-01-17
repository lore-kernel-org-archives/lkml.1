Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbZAQF1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbZAQF1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 00:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZAQF04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 00:26:56 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:41689 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZAQF0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 00:26:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wUWb9X4rEjAxfr3q4DpY09nQoNrGdZuP6bHBOlmkSBxk2rNsG3x+xPWHiD7wLvBsVc
         Hp/gMdU8N98CVeZtA4kJmQ8OxMYg50t67dnzMh4dqngpX7v4bVf9DA/u2oLtxvJs8nJy
         KRcZ719fxFPobdahrkhHDdi3tHLDoC1OAVQLg=
MIME-Version: 1.0
In-Reply-To: <21512985.post@talk.nabble.com>
References: <21512362.post@talk.nabble.com>
	 <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com>
	 <21512985.post@talk.nabble.com>
Date: Sat, 17 Jan 2009 00:26:53 -0500
Message-ID: <3e8340490901162126u109da9cbu7292fddf6d832723@mail.gmail.com>
Subject: Re: Kernel vs user memory
From: Bryan Donlan <bdonlan@gmail.com>
To: sidc7 <siddhartha.chhabra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 11:21 PM, sidc7 <siddhartha.chhabra@gmail.com> wrote:
>
> I am not an expert, just started doing some kernel programming and code
> reading, so as far as I understand, memory can be either mapped to user
> space or kernel space, if its neither in user and kernel, as you said, the
> division is not easy, where will the memory be mapped to, is there any other
> special region ?

For each memory space (usually one per process), the kernel sets up a
page table. The lower PAGE_OFFSET bytes are mapped differently for
each such space, but above the address PAGE_OFFSET, every process has
the same mappings - this is what one usually thinks of when one hears
'kernel memory'. The kernel then puts its data structures in this
upper area, so that the addresses of these structures remains the same
in all processes. Of course, these pages are only accessible in kernel
mode - attempting to access them at all from a user process will get
you a segmentation fault.

Note also that while on 64-bit platforms the kernel memory map
generally includes all of physical RAM, on 32-bit platforms such as
the x86, there's typically only about 700mb of physical RAM mapped in
this area by default; the remainder of RAM (if any) can only be used
for page/buffer cache and process memory.
