Return-Path: <linux-kernel-owner+w=401wt.eu-S964860AbXB0ANe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbXB0ANe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965267AbXB0ANd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:13:33 -0500
Received: from terminus.zytor.com ([192.83.249.54]:33156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860AbXB0ANc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:13:32 -0500
Message-ID: <45E376E8.8020901@zytor.com>
Date: Mon, 26 Feb 2007 16:10:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, a.gruenbacher@computer.org,
       bunk@stusta.de, linux-kernel@vger.kernel.org, jmorris@redhat.com,
       dwmw2@infradead.org
Subject: Re: include/linux/xattr.h: how much userpace visible?
References: <20060724085701.B2083275@wobbly.melbourne.sgi.com> <200607242031.11815.a.gruenbacher@computer.org> <45E36D39.2030605@zytor.com> <20070226.154308.112620497.davem@davemloft.net> <45E372CA.9020709@zytor.com> <20070227000318.GA3448@infradead.org>
In-Reply-To: <20070227000318.GA3448@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> What's the problem of exposing all these APIs unconditionally?
> glibcs should either use all information from the linux/ headers
> or nothing at all, but not depend on hiding some bits.

It's not always that simple.  In particular, in some files there might 
be typedefs or structure tags that step on libc's namespace (but are 
useful to other libcs), but ABI constants that are universally useful.

One way to deal with the particular issue of structure tags which is 
probably even more useful is:

#if defined(__KERNEL__) || defined(__KERNEL_EXPORT_STRUCTURES)
# define __kstruct_stat stat
#endif

struct __kstruct_stat {
	/* ...foo... */
};

... which lets the libc export it into whatever namespace it wants by 
#defining __kstruct macros accordingly.

	-hpa
