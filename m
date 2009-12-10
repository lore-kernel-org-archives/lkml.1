Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbZLJXXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbZLJXXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbZLJXXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:23:09 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:45264 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbZLJXXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:23:08 -0500
Message-ID: <4B218249.4040501@lougher.demon.co.uk>
Date: Thu, 10 Dec 2009 23:20:41 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: dedekind1@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       Tim Bird <tim.bird@am.sony.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into
 a 	separate file
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>	 <20091207145705.cd30cae8.akpm@linux-foundation.org>	 <4B1ED122.3040309@lougher.demon.co.uk>	 <1260352852.19669.1253.camel@localhost>	 <4B2042FA.8080406@lougher.demon.co.uk> <10f740e80912100201l6d83588evff46e95ec96d0aed@mail.gmail.com>
In-Reply-To: <10f740e80912100201l6d83588evff46e95ec96d0aed@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Hi Phillip,
> 
> On Thu, Dec 10, 2009 at 01:38, Phillip Lougher
> <phillip@lougher.demon.co.uk> wrote:
>> Artem Bityutskiy wrote:
>>> Did you consider using cryptoapi? UBIFS uses zlib/lzo in cryptoapi - it
>>> is a very clean way.
> 
> Exactly my question, as that's why the Crypto API was extended with
> support for partial (de)compression in the first place ;-)
> 

Your cryptoapi patches are on my "must do something about them" list, I've
not forgotten them :-)   The lack of lzma in the crypotapi made moving
solely to the cryptoapi difficult, when I wanted to add lzma decompression
support.

The decompressor framework is my _solution_ to this problem.  This allows
cryptoapi support to be added as additional decompression_wrapper, with
multiple compression types using the crptoapi wrapper as appropriate.
This has the advantage it allows Squashfs to use the cryptoapi (with
its advantages), without needlessly restricting Squashfs to the
compression algorithms supported by the cryptoapi.

Let's get this mainlined, and then we can work on getting your
cryptoapi patches integrated into that.  That'll make me happy,
and hopefully you'll be happy too?

Thanks

Phillip
