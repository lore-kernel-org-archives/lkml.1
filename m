Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbYD1JKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbYD1JKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYD1JJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:09:49 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:8494 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbYD1JJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kiNt/9gfAf2FsRxn8DM6hy0vArqbBXKXdPLwhGD8HL7fnQuUcJp/2OLcOxwHVGWuP4oPjVuY4jMOmKgH3O6eRETbIhAWw+VZy4S4uR9NpHXTwU07IVmejSk627jIvTRXxLNFA6sNmg0wTEUW1RMQiDyN4QV4cccKt+cynEfCoNY=
Message-ID: <86802c440804280209x401fc223w3d272c6c365e58af@mail.gmail.com>
Date: Mon, 28 Apr 2008 02:09:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mika Fischer" <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com
In-Reply-To: <48158CF3.60004@zoopnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801202256.48365.yinghai.lu@sun.com>
	 <20080122165125.GA17992@elte.hu>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <86802c440804272350y33d69a32o5533dc01dc5a6c96@mail.gmail.com>
	 <48158CF3.60004@zoopnet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 1:38 AM, Mika Fischer <mika.fischer@zoopnet.de> wrote:
> Hi Yinghai,
>
>  Yinghai Lu schrieb:
>
> >>  reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>  >>  reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
>  >>  reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>  >>  reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>  >>  reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>  >>
>  >>  which screws up the X server's attempt to map the video memory at
>  >>  0xd0000000.
>  >
>  > please try the patch at
>  >
>  > http://lkml.org/lkml/2008/4/28/52
>  >
>  > with mtrr_chunk_size=1g, and you should get
>  >
>  > you should get
>  >>  reg00: base=0x00000000 ( 0MB), size=2048MB: write-back, count=1
>  >>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>  >>  reg02: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>  >>  reg03: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>  >>  reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>
>  Wow, thanks a lot for this patch! It almost works. This is what I get
>  with mtrr_chunk_size=1g:
>
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>  reg02: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
>  reg03: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
>  reg04: base=0x100001000 (4096MB), size=   4KB: write-back, count=1
>  reg05: base=0x100002000 (4096MB), size=   8KB: write-back, count=1
>  reg06: base=0x100004000 (4096MB), size=  16KB: write-back, count=1
>  reg07: base=0x100008000 (4096MB), size=  32KB: write-back, count=1
>
>  And this is what I get without mtrr_chunk_size=1g:
>
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>  reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
>  reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
>  reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
>  reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
>  reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
>  reg06: base=0x100001000 (4096MB), size=   4KB: write-back, count=1
>  reg07: base=0x100002000 (4096MB), size=   8KB: write-back, count=1
>
>  I attached these outputs and the dmesgs to the bug report:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=10508
>
>  dmesg with mtrr_chunk_size=1g:
>  http://bugzilla.kernel.org/attachment.cgi?id=15945
>
>  dmesg without mtrr_chunk_size=1g:
>  http://bugzilla.kernel.org/attachment.cgi?id=15946
>

thanks for testing

please check
http://lkml.org/lkml/2008/4/28/115

also, can you try 64bit too?

YH
