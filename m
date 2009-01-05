Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZAEVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZAEVSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAEVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:18:22 -0500
Received: from mail.lang.hm ([64.81.33.126]:54543 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZAEVSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:18:22 -0500
Date: Mon, 5 Jan 2009 14:20:42 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
In-Reply-To: <20090104112919.GC7632@localhost>
Message-ID: <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>
References: <20090102174845.GD5372@localhost> <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost>
 <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Cyrill Gorcunov wrote:

I assume you want this instead of the prior patches. I will test this 
shortly.

David Lang

> ---
> include/linux/mmzone.h |    1 +
> 1 file changed, 1 insertion(+)
>
> Index: linux-2.6.git/include/linux/mmzone.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/mmzone.h
> +++ linux-2.6.git/include/linux/mmzone.h
> @@ -980,6 +980,7 @@ extern struct mem_section mem_section[NR
>
> static inline struct mem_section *__nr_to_section(unsigned long nr)
> {
> +	BUG_ON(SECTION_NR_TO_ROOT(nr) >= NR_SECTION_ROOTS);
> 	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
> 		return NULL;
> 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
>
