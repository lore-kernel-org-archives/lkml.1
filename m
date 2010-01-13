Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288Ab0AMA07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0AMA07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154Ab0AMA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:26:58 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54534 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0AMA05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:26:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n6Sp6dxL7bfRbJf27SfCFx94nL5YBugTnMAkF4Alv0e6wHCs3lTQYIrxZ5RNFHmpr2
         1aMa4NS0GlXQwawZYNzxQjh1sVMwiyZEgvVmTAYtPlMZ7LFqOqa9x/bpXxSaqQNzrYBp
         4Dc/hT77nDMvFKj60Z5+gmkI+ivcGs2Uia9ko=
MIME-Version: 1.0
In-Reply-To: <20100113102254.332dbf33.sfr@canb.auug.org.au>
References: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
	 <20100112083013.1dad8a8d.randy.dunlap@oracle.com>
	 <20100113102254.332dbf33.sfr@canb.auug.org.au>
Date: Wed, 13 Jan 2010 00:26:56 +0000
Message-ID: <bffbecbb1001121626j61fab30aj87048a17a2b091ff@mail.gmail.com>
Subject: Re: linux-next: Tree for January 12 (unlzo)
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, albin.tonnerre@free-electrons.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 11:22 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Randy,
>
> On Tue, 12 Jan 2010 08:30:13 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:53: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'parse_header'
>> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:90: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'unlzo'
>>
>> Problem is the "INIT" there, seems to be undefined.
>
> Caused by an interaction between Linus' tree and the squashfs tree that
> is being worked on.  It should not occur with today's linux-next as the
> squashfs changes have been removed pending a fix.

This problem is caused by the introduction of the unlzo code in Linus'
tree, and some patches in
the squashfs-next tree that move things out of
include/linux/decompress/mm.h into separate
xxx_mm.h files for each decompressor.  These parches were, obviously,
done before the unlzo
code was present.

I've fixed the patches in the squashfs-next tree for unlzo, and the
breakage should be fixed :-)

Thanks

Phillip
