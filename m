Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbXGPRfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbXGPRfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXGPRfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:35:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXGPRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:35:40 -0400
Message-ID: <469BAC68.50409@zytor.com>
Date: Mon, 16 Jul 2007 10:35:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: x86 setup code rewrite in C - revised
References: <739046.56993.qm@web26915.mail.ukl.yahoo.com>
In-Reply-To: <739046.56993.qm@web26915.mail.ukl.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain wrote:
> 
>   The only time I ever needed this "end line recalculation" was when the heigh in
>  graphic lines was not a multiple of the character heigh - i.e. 640x350 with 8x16
>  or 8x8 chars - some VGA adapters do not hide the bottom graphic lines.
>   The function vga_set_480_scanlines() is not called, and the protect bit is never
>  cleared - the video BIOS leaving those low index register protected.
>   The function vga_recalc_vertical() (or its assembler equivalent) is probably
>  perfectly called but because the protect bit is never cleared, the few graphic
>  line are displayed during the whole Linux text session...
>   I have myself never seen any other problems when the graphic heigh is a multiple
>  of the character heigh - tested on ~40 video boards.
> 

OK, I see what you mean.  This would be a problem if:

- the VGA BIOS leaves the protected bit set
- the user enables vertical recalculation
- the size crosses a multiple of 256

It is a bug (ported from the assembly) and fortunately quite easy to
fix.  I don't know why I missed this when I looked before.

	-hpa
