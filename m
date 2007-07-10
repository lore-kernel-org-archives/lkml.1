Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbXGJPwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbXGJPwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXGJPv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:51:58 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXGJPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:51:57 -0400
Message-ID: <4693AA56.9040109@zytor.com>
Date: Tue, 10 Jul 2007 08:48:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de>
In-Reply-To: <200707101721.58937.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 10 July 2007 16:16:29 Segher Boessenkool wrote:
>>> gcc for i386 can be used with the assembly prefix ".code16gcc" to  
>>> generate
>>> 16-bit (real-mode) code.  This header file provides the assembly  
>>> prefix.
>> This only works correctly with newer GCCs if you pass the
>> -fno-toplevel-reorder option (and it only works on older
>> GCC versions by accident).
> 
> And on older ones (gcc-3.3-hammer / 3.4 / 4.0 ) -fno-unit-at-a-time
> 
> Still it seems quite fragile to me agreed.

The alternative, of course, is to compile to an .s file and insert
.code16gcc into the .s file.  This makes the Makefile uglier, but would
be more resilient against oddball gcc changes.

I'm a bit surprised about the claim w.r.t. -fno-unit-at-a-time (although
I guess that is the default and one would thus typically not see this.)
 Got any pointers why that would cause a global asm() to be scrambled
around?

	-hpa
