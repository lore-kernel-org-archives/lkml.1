Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZHOJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZHOJQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZHOJQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:16:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:63291 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZHOJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:16:17 -0400
Message-ID: <4A867CA5.1050103@gmail.com>
Date: Sat, 15 Aug 2009 12:15:17 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][RFC] security: constify seq_operations
References: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org> <20090811143643.GA15096@us.ibm.com> <alpine.LRH.2.00.0908120129290.22015@tundra.namei.org> <Pine.LNX.4.64.0908112138290.9996@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908112138290.9996@ask.diku.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Aug 2009 09:15:22.0740 (UTC) FILETIME=[EAE95B40:01CA1D88]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 10:47 PM, Julia Lawall wrote:
> A while ago I made a semantic patch to introduce const on file_operations
> and and input_device_id types.  I tested it on 142 files in which the
> change had already been made and got the same result in each case.  I have
> run it on linux-next and obtained the attached result.  However, I have
> not checked any of these results, so this is not meant as a submitted
> patch, but as a starting point for someone who wants to look further into
> the problem.
>
> julia
>

snip

> diff -u -p a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> --- a/fs/ubifs/xattr.c 2009-06-27 09:35:06.000000000 +0200
> +++ b/fs/ubifs/xattr.c 2009-08-11 22:42:24.000000000 +0200
> @@ -80,7 +80,7 @@ enum {
>
>   static struct inode_operations none_inode_operations;
>   static struct address_space_operations none_address_operations;
> -static struct file_operations none_file_operations;
> +static const struct file_operations none_file_operations;

Fixed this in UBIFS. Also made the inode operation const. Thanks.
Pushed to ubifs-2.6.git:
http://git.infradead.org/ubifs-2.6.git/commit/2d132c333e9f88684801c9b80e6ba086da4f0ea0

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
