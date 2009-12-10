Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbZLJWqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbZLJWqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762047AbZLJWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:46:14 -0500
Received: from nbd.name ([88.198.39.176]:33683 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762034AbZLJWqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:46:12 -0500
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 17:46:11 EST
Message-ID: <4B217421.5000802@openwrt.org>
Date: Thu, 10 Dec 2009 23:20:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, dedekind1@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       Tim Bird <tim.bird@am.sony.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into
 a 	separate file
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>	 <20091207145705.cd30cae8.akpm@linux-foundation.org>	 <4B1ED122.3040309@lougher.demon.co.uk>	 <1260352852.19669.1253.camel@localhost>	 <4B2042FA.8080406@lougher.demon.co.uk> <10f740e80912100201l6d83588evff46e95ec96d0aed@mail.gmail.com> <4B21656B.1090607@lougher.demon.co.uk>
In-Reply-To: <4B21656B.1090607@lougher.demon.co.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-12-10 10:17 PM, Phillip Lougher wrote:
> Geert Uytterhoeven wrote:
>> 
>>> Yes I did consider using the cryptoapi, but this doesn't have support for
>>> lzma in mainline.
>> 
>> IIRC, Felix Fietkau added support for that for OpenWRT...
>> 
> 
> Yes, but it isn't in mainline, and OpenWRT don't appear to have tried to submit
> it.  IMHO the major problem with their patch is it uses a second private copy
> of lzma, rather than being a wrapper around the pre-existing lzma implementation.
> I don't think it's going to be easy to get a second lzma implementation accepted
> into mainline, when it took so long to get one accepted.  I have nothing against
> the cryptoapi, but it doesn't seem likely to be getting lzma support anytime soon.
> 
> As I previously said my aim is to use the pre-existing lzma implementation.  Unless
> it is stupendously bad (which it isn't), that seems to be the quickest, easiest and
> best way to get lzma support into Squashfs.
The main reason why my implementation couldn't be done as a simple
wrapper around the existing implementation is that it reuses the
caller's split output buffers instead wasting precious RAM by allocating
a contiguous buffer big enough to cover the entire block.
Especially at bigger block sizes (which provide better compression),
this probably has noticeable effects on tiny embedded systems with
little RAM.

- Felix
