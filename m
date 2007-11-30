Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXK3H6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXK3H6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 02:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXK3H6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 02:58:30 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:58239 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbXK3H63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 02:58:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ABYzXPI/y7L/Fr/0ApBK8DzL9nEy79fY/y8Rhu59vwmrMmVh4XZKG/DveqzdaZ/3/R0uNmUymlI2UEVXaUxiSBezmXwYGnvpyiyC7JjGPIiSnZGHdJBfu/X7OJw02qOI4Iftld6YvS3ibiLXAn418vzilYu6lcRVJV7bhkmzYXM=
Message-ID: <5eeb9ad90711292358q2e8cf5few8d9c1b99195e1ee@mail.gmail.com>
Date: Fri, 30 Nov 2007 08:58:28 +0100
From: DM <dm.n9107@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: [RFC v2] Documentation about unaligned memory access
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071129161523.E0C349D4B52@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071129161523.E0C349D4B52@zog.reactivated.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 5:15 PM, Daniel Drake <dsd@gentoo.org> wrote:
[...]
> To avoid the unaligned memory access, you would rewrite it as follows:
>
>        void myfunc(u8 *data, u32 value)
>        {
>                [...]
>                value = cpu_to_le32(value);
>                put_unaligned(value, data);
>                [...]
>        }
>
> The get_unaligned() macro works similarly. Assuming 'data' is a pointer to
> memory and you wish to avoid unaligned access, its usage is as follows:
>
>        u32 value = get_unaligned(data);
>
> These macros work work for memory accesses of any length (not just 32 bits as
> in the examples above). Be aware that when compared to standard access of
> aligned memory, using these macros to access unaligned memory can be costy in
> terms of performance.
>

The get_unaligned call above will not do what you intended given the,
at least as I read it, implied context of myfunc. Since data is a u8*
it will only get one byte of data. To avoid misunderstandings the code
should probably read:

u32 value = get_unaligned((u32 *)data);

/DM
