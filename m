Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZEaCFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZEaCFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 22:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZEaCFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 22:05:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbZEaCFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 22:05:07 -0400
Date: Sat, 30 May 2009 19:04:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data
 sanitization
In-Reply-To: <20090531015537.GA8941@oblivion.subreption.com>
Message-ID: <alpine.LFD.2.01.0905301902530.3435@localhost.localdomain>
References: <20090531015537.GA8941@oblivion.subreption.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 May 2009, Larry H. wrote:
>
> This patch doesn't affect fastpaths.

This patch is ugly as hell.

You already know the size of the data to clear.

If we actually wanted this (and I am in _no_way_ saying we do), the only 
sane thing to do is to just do

	memset(buf->data, 0, N_TTY_BUF_SIZE);
	if (PAGE_SIZE != N_TTY_BUF_SIZE)
		kfree(...)
	else
		free_page(...)


but quite frankly, I'm not convinced about these patches at all.

I'm also not in the least convinced about how you just dismiss everybodys 
concerns.

		Linus
