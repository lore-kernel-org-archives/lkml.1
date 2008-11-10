Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYKJLtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYKJLtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 06:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbYKJLtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 06:49:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:65480 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYKJLtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 06:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JeYBairtpvTmCrB57P/O2KFHoAyPy4mVl9n7Pi6BQ9L5pbO2gkV/1Jfv+IKjRp+g5N
         fBK38mf16lCo31w7rspOQwXSucZrnZDuRSKxgxzD589EqcRq5qasVOrNa1HYs1lWHalH
         6B2ngNp4Uzma5t9ZmQaFKHdrXMJ00XncLwhdU=
Message-ID: <87a5b0800811100349n435785by27ebc4e495bb7985@mail.gmail.com>
Date: Mon, 10 Nov 2008 11:49:22 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [RFC-PATCH 1/5] unaligned: introduce common header
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226290940.5478.3.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225908976.5991.180.camel@brick>
	 <87a5b0800811080447m2cebebb7j77afe9592f72ab11@mail.gmail.com>
	 <1226290940.5478.3.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 4:22 AM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:

(add back lkml cc that I mistakenly dropped)

> On Sat, 2008-11-08 at 12:47 +0000, Will Newton wrote:
>> On Wed, Nov 5, 2008 at 6:16 PM, Harvey Harrison
>> <harvey.harrison@gmail.com> wrote:
>>
>> > The memmove-based arches (m32r, xtensa, h8300) are likely going to be fine with this change
>> > barring compiler bugs that made them go with memmove in the first place.
>>
>> As I understand it the need for the memmove implementation is not
>> compiler bugs but default struct alignment. The packed struct
>> implementation will only work with compilers where structs can be
>> aligned on byte boundaries, it's fairly common for RISC architectures
>> to align structs to 4 or 8 byte boundaries.
>
> Which I believe is disabled entirely using __attribute__((packed)), no?

As far as I am aware the packed attribute is handled in this way for
some toolchains (arm in particular). Not everybody does it, and for
good reasons. For example if I have this struct on an architecture
with 8 byte default struct alignment:

struct foo {
    u64 big_data;
    u8 small_data;
    u32 medium_data;
} __attribute__((packed));

Should big_data be accessed as 8 byte load instructions rather than
one 64bit load instruction? It's a pretty large performance penalty to
pay when all I really want is for medium_data to be accessed
correctly.
