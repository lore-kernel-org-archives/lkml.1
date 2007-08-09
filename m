Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXHIWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXHIWIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXHIWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:08:08 -0400
Received: from sandeen.net ([209.173.210.139]:13869 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXHIWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:08:07 -0400
Message-ID: <46BB9045.6020107@sandeen.net>
Date: Thu, 09 Aug 2007 17:08:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2] limit minixfs printks on corrupted dir i_size, CVE-2006-6058
References: <8Qlff-3jX-29@gated-at.bofh.it> <8Qn7m-6li-27@gated-at.bofh.it> <E1IJFr4-0000is-Ox@be1.lrz>
In-Reply-To: <E1IJFr4-0000is-Ox@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:

> Warning: I'm only looking at the patch.
> 
> You are supposed to print an error message for a user, not to write in a
> chat window to a 1337 script kiddie. OK, you just matched the current style,
> and your patch is IMHO OK for a quick security fix, but:
> 
> - Security fixes should be CCed to the security mailing list, shouldn't they?
>   (It might be security@ or stable@, I'll remember tomorrow, but then I'd
>    forget to comment)

ok.

> - Imagine you have three mounts containing a minix fs, how can you tell which
>   one is the the defective one?

good point.

> - The message says "minix_bmap", while the patch suggests it's in
>   block_to_path. Therefore I asume "minix_bmap" to have only random
>   informational value.

Yup, you're right.

> - Does block < 0 or block > $size make a difference?

well, block > size is likely to arrive from a corrupt i_size, and the
insistence upon going ahead and checking the next page after
encountering an error on the last one... I don't have any scenario in
mind where we'd be repeatedly trying to check blocks < 0.

> - the printk lacks the loglevel.

As do all other printk's in minixfs... (hm and 11,619 other printk's in
the kernel :) )

> - Asuming minix supports error handling, shouldn't it do something?
> 
> I'd suggest a message saying something like "minix: Bad block address on
> device 08:15, needs fsck".

Fair enough, as you said I was just fixing up the issue, not rewriting
the code around it.  But yes, I should probably have considered at least
a better message here.  I can fix this up & resend.  But I'm not
promising to audit all other printk's in minixfs this time around.  ;-)

-Eric
