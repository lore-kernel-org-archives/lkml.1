Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYIHTO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYIHTO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYIHTOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:14:21 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58713 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYIHTOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sLV8sZ+EZxD0Kw8zkrHD2mZ6dh36vkR9LPxtmC5YFE4Y+div2nm0UBz62vMfjqddI5
         07+jy3WPnDHdxkIY5CQLBjUS9tY9w48FRPzEBlza0taxUU1ev95WqwdJe573zUjIjFyJ
         YRkOwwGvf+L9VOAJ24Gqbiw/1eQPg268miHpk=
Message-ID: <68676e00809081214h49eb07d4tb6145e8b47b00768@mail.gmail.com>
Date: Mon, 8 Sep 2008 21:14:18 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <86802c440809081104i23b477e1w62bd5967b79529cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org>
	 <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
	 <86802c440809060906h721d6243t4a3b5fb604a9d7b3@mail.gmail.com>
	 <68676e00809081054j3fb9c5bq76c9a6aceea35aa2@mail.gmail.com>
	 <86802c440809081104i23b477e1w62bd5967b79529cb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 8:04 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Mon, Sep 8, 2008 at 10:54 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>
> can you post boot log with working kernel + "debug"?

This is the map of the early reservations (will send the dmesg + debug later):

[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00bbf90000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000d012b8]    TEXT DATA BSS ==>
[0000200000 - 0000d012b8]
[    0.000000]   #3 [00037dc000 - 00040fe2d9]          RAMDISK ==>
[00037dc000 - 00040fe2d9]
[    0.000000]   #4 [000009c800 - 0000100000]    BIOS reserved ==>
[000009c800 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==>
[0000008000 - 000000b000]

As a side note: I've bigger older (2.6.26) kernels that boots fine,
and smaller 2.6.27 kernels that do not work, e.g. this one:

Overlapping early reservations b71000-effb43 RAMDISK to 200000-c84ecf
TEXT DATA BSS

Luca
