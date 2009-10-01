Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZJAQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZJAQmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZJAQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:42:43 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62926 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZJAQmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=HI0NGSIthuK9dzSHuxAQ5fj5w1y9GpZGvHvQtlxhQh+4KuFFOgjZj+HuahME0L3JhV
         w8aqJQKdMPJqkHzRz9hJDeIf5THlCTom5hkSb+TvnPiAVcvrpTR2VS/4Ca3XRNhErv9U
         0hBvmBN2JLP+QItWU/YgvJaXFLzvFYH6KfToI=
MIME-Version: 1.0
In-Reply-To: <20091001030733.GS24383@mit.edu>
References: <cb0375e10909301954y68e18290m97e9fecfbc5aa6e3@mail.gmail.com>
	 <20091001030733.GS24383@mit.edu>
Date: Thu, 1 Oct 2009 12:42:45 -0400
X-Google-Sender-Auth: 687b4535a4a57321
Message-ID: <cb0375e10910010942m31c40ff5kc261deaa87969e55@mail.gmail.com>
Subject: Re: 2.6.32-rc1 oops in ext4
From: Andrew Lutomirski <andy@luto.us>
To: Theodore Tso <tytso@mit.edu>, Andrew Lutomirski <andy@luto.us>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:07 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Sep 30, 2009 at 10:54:26PM -0400, Andrew Lutomirski wrote:
>> All I did was boot Fedora 11 and open a Konsole.  I'm running
>> 84d88d5d4efc37dfb8a93a4a58d8a227ee86ffa4.
>
> I'm pretty sure this patch should fix things; can you confirm?
>
>                                              - Ted
>
> commit 1f94533d9cd75f6d2826018d54a971b9cc085992
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Wed Sep 30 22:57:41 2009 -0400
>
>    ext4: fix a BUG_ON crash by checking that page has buffers attached to it
>
>    In ext4_num_dirty_pages() we were calling page_buffers() before
>    checking to see if the page actually had pages attached to it; this
>    would cause a BUG check crash in the inline function page_buffers().
>
>    Thanks to Markus Trippelsdorf for reporting this bug.
>
>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I patched that onto the same kernel from git and it seems to work.

Tested-by: Andy Lutomirski <luto@mit.edu>

Thanks,
Andy
