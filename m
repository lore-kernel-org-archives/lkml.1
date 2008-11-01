Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYKAQti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYKAQti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYKAQt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:49:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbYKAQt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:49:26 -0400
Date: Sat, 1 Nov 2008 09:49:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH] saner FASYNC handling on file close
In-Reply-To: <20081031232830.GX28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0811010949020.6226@nehalem.linux-foundation.org>
References: <20081031232830.GX28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Oct 2008, Al Viro wrote:
>
> 	As it is, all instances of ->release() for files that have
> ->fasync() need to remember to evict file from fasync lists; forgetting
> that creates a hole and we actually have a bunch that *does* forget.
> 
> 	So let's keep our lives simple - let __fput() check FASYNC in
> file->f_flags and call ->fasync() there if it's been set.  And lose
> that crap in ->release() instances - leaving it there is still valid,
> but we don't have to bother anymore.
> 
> Comments?

This looks like "obviously the right thing". Done.

		Linus
