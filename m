Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbYE0SZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbYE0SZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbYE0SZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:25:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:28584 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbYE0SZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mH2b5qIJeNmm7u9eTNjtppMpbZKX6p0dNpMmKnVwLG7G7+kDFjoZllFZM5S0gOQ7CORVvnjtx1jqYnY3nb+M4UMKWRb1YQKFiSZXM91gk1qU1JPDvM9W3XkS17/sW7SuPSpg+e7krTxK/bRRzm4d6x7f+KPK/MBYRUb7QCfi53E=
Message-ID: <84144f020805271125o74420890id4e3bc6560d7bcfa@mail.gmail.com>
Date: Tue, 27 May 2008 21:25:02 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Sesterhenn" <snakebyte@gmx.de>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Cc: linux-kernel@vger.kernel.org, "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "James Morris" <jmorris@namei.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080526143422.GA3203@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526143422.GA3203@alice>
X-Google-Sender-Auth: 589fa2e70c278170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, May 26, 2008 at 5:34 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> i enabled CONFIG_SECURITY on current git and get tons of
> Redzone overwritten errors during early boot, even
> with CONFIG_SECURITY_CAPABILITIES and CONFIG_SECURITY_NETWORK
> disabled. After a while it ends with a kernel panic
> saying: not syncing: Out of memory and no killable process...
> Root partition is ext3 format.
>
> At the moment i dont have a camera at hand, so i'll try
> to write down everything which looks interesting, please tell
> me if i missed something.
>
> The first 24 Bytes of the overwritten section contain
> zeros. Then we have a constant 0x18, and three changing
> values. the next three bites contain exactly the same
> values, first the 0x18, then the two changing ones.
>
> The only value i found so far matching the 0x18 and
> which might be related to CONFIG_SECURITY is CAP_SYS_RESOURCE
> defined in /include/linux/capability.h
>
> BUG hugetlbfs_inode_cache: Redzone overwritten
>
> INFO: 0xccd8e250-0xccd8e253. First byte 0x0 instead of 0xbb
> Info: Slab 0xc119d1c0 objects=12 used=0 fs=0xccd8e000 flags=0x400020c3
> Info: Object 0xccd8e00 offset=0 fp=0xccd8e280
>
> Object 0xccd8e00: 00 00 00 ...
> Object 0xccd8e10: 00 00 00 00 00 00 00 00 00 18 e0 d8 cc 18 e0 d8 cc
> Object 0xccd8e20  00 00 00 ...

Unfortunately this transcribe is not useful for serious debugging. The
object ranges in the printout ("0xccd8e250" vs "0xccd8e00") and you
didn't write down contents of the "Redzone" range that has the
corrupting data. So a serial console output or a picture of the oops
would be much appreciated.
