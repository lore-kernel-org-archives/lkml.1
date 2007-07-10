Return-Path: <linux-kernel-owner+w=401wt.eu-S1762769AbXGJT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769AbXGJT5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbXGJT5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:57:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:36938 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632AbXGJT5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:57:22 -0400
In-Reply-To: <200707101721.58937.ak@suse.de>
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Date: Tue, 10 Jul 2007 21:57:11 +0200
To: Andi Kleen <ak@suse.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> gcc for i386 can be used with the assembly prefix ".code16gcc" to
>>> generate
>>> 16-bit (real-mode) code.  This header file provides the assembly
>>> prefix.
>>
>> This only works correctly with newer GCCs if you pass the
>> -fno-toplevel-reorder option (and it only works on older
>> GCC versions by accident).
>
> And on older ones (gcc-3.3-hammer / 3.4 / 4.0 ) -fno-unit-at-a-time

...which inhibits even more optimisations.  Still not too
important, but the code size difference probably is
noticeable.

> Still it seems quite fragile to me agreed.

Well at least with -fno-toplevel-reorder it is guaranteed
to work (not the same thing as "is working", heh, but fairly
close).

It seems to me GCC should grow an option to insert .code16gcc
by itself (-m16 perhaps?)  Or GAS could get a flag to include
a file as a prelude before the main thing.  Neither will help
Linux right now of course.


Segher

