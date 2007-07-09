Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbXGIW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbXGIW7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbXGIW7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:59:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:65047 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845AbXGIW7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EyGoOQ2stL5g4G9AVpVIHbPVPnAbenBLRYlI3MJEJcg6ctuAcJr5cZlLwtDx8Gi+v+Zbbci1re0CmfE35vHZHwzQEIOdAR0Exmf3/h9EgAVq9I/1XoXXCvBQITJPEDxP/fXuE5gPDOpRqwdJOIAljmR9cBYXIrKNlJMHV8Od9C4=
Message-ID: <a781481a0707091559x7103fea6vc74c06f451e66d55@mail.gmail.com>
Date: Tue, 10 Jul 2007 04:29:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: Documentation of kernel messages (Summary)
Cc: "Kunai, Takashi" <kunai@linux-foundation.jp>, holzheu@linux.vnet.ibm.com,
       "Rob Landley" <rob@landley.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       hpa@zytor.com, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <200707090901.47900.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <1182957079.6643.13.camel@localhost.localdomain>
	 <4691C480.5010600@linux-foundation.jp>
	 <200707090901.47900.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/07, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag, 9. Juli 2007 schrieb Kunai, Takashi:
> > (b)printk hashes and (c)Format strings. (a) seems difficult to get
> > supports from kernel developers and (c) lacks uniqueness of each
> > message. Though (b) also lacks uniqueness, adding component id and/or
>
> We have generators for hash functions that guarantee unique results
> for a set of inputs.

Right, perfect hash generators require the input set to be known
*a priori*.

> They are even GPLed. As you are operating against
> a known target, that should work.

But, I'm not sure they'd be operating against a known target -- I don't
really know what exactly would be hashed, but if it's kernel printk()
messages (the format string, obviously), then please remember that
new messages would get added all the time, and unless we're also
willing to change the hash function every time a printk() gets added
to the kernel (whew!) it's going to be a problem -- especially because
we don't really want to generate new hash functions for every kernel
version / or for every kernel build, because we'd obviously like the
same error message to hash to the same value across versions.

If we really care about uniqueness, the only solution I see is to use
a strong/cryptographic hash function (say SHA-1, which would never
change in the future) that generates the hashes for all the printk()
messages that are getting compiled-in at build-time ... but it would be
slow, of course.

Satyam
