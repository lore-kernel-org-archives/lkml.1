Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYCDDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYCDDIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbYCDDIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:08:14 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:41687 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbYCDDIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o8QKT3XmqTCWe2HDINDSGNAVXjBAsHeamvymEGgOfsJDrAj9EvhtHMgx4m6+TW95ZEVXJ9YCidujzzHVgJI8LLOvX0UdCJ6lvHwEsugsz4wR3/u/vh9dyYZ+r7kaJovIrYlfY/CMVjHf+zgz0eJsHy8m4oaONY4wVh2oa1W/1Pg=
Message-ID: <2cd57c900803031908p376f86fx54aa74302e8b2b18@mail.gmail.com>
Date: Tue, 4 Mar 2008 11:08:11 +0800
From: "Qi Yong" <qiiyoong@gmail.com>
To: "Postfix developers" <postfix-devel@postfix.org>
Subject: Re: var_mailbox_limit 32bit limit
Cc: "Qi Yong" <qiyong@fc-cn.com>, linux-kernel@vger.kernel.org,
       lesanti@gmail.com
In-Reply-To: <20080303180437.B33A51F3E9A@spike.porcupine.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bca00b6d0803030416o3a565956vc59196a5bc7c40fe@mail.gmail.com>
	 <20080303180437.B33A51F3E9A@spike.porcupine.org>
X-Google-Sender-Auth: 636307784690d6c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2008, Wietse Venema <wietse@porcupine.org> wrote:
> Leandro Santi:
>
> > On 3/1/08, Qi Yong <qiiyoong@gmail.com> wrote:
>  > > On 29/02/2008, Leandro Santi <lesanti@gmail.com> wrote:
>  > >  > On 2/29/08, Qi Yong <qiiyoong@gmail.com> wrote:
>  > >  >  >  var_mailbox_limit is int type. This caps mailbox_size_limit to 2147483647
>  > >  >  >  at the maximum. I'd like to make var_mailbox_limit a long integer. What do
>  > >  >  >  you think of this idea? And objections? I have large mboxs here. Thanks.
>
>
> Using long won't help, especially not when int==long like it is
>  on 32-bit boxes.

It should work. long are 64bit on Linux x86_64 or FreeBSD amd64. And
most if not all newer servers support that 'long mode'.

>
>  To handle >2GB files, you either need a grown-up OS, or you need

(Seems people here think Linux is 'toy operating' and not 'grown-up'.
Actually if you have to blame, you'd blame GNU, not the kernel.)

I think that GNU/Linux was supporting large file in a different way
from *BSD as you think was because they were afraid making off_t 64bit
would break old wrong things. And there are also other considerations.
Then they introduced off64_t or loff_t.

But the above does not cover all the facts. On Linux/x86_64, off_t is
64 bit too. The library has things like _FILE_OFFSET_BITS,
__USE_FILE_OFFSET64 and typedef __off64_t off_t, check
/usr/include/unistd.h.

>  to recompile Postfix in the large file model.

Is Postfix has a large file model?

>
>  However, that may or may not be sufficient. You may also have to
>  to recompile libraries that Postfix depends on in the large file
>  model.

I think the pre-built libraries in an amd64 distro are already done so.

So my proposal is using long for var_mailbox_limit et al in order to
get rid of the 2G limit on amd64. And if that is acceptable, I'd like
to try.
-- 
Qi Yong
