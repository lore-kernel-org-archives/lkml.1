Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZEaGex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZEaGex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZEaGep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:34:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45804 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZEaGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:34:44 -0400
Message-ID: <4A2223FE.3000309@cs.helsinki.fi>
Date: Sun, 31 May 2009 09:30:22 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page	allocator
References: <20090530082048.GM29711@oblivion.subreption.com> <20090530173428.GA20013@elte.hu> <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu> <20090530184534.GJ6535@oblivion.subreption.com> <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com> <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com> <20090530213311.GM6535@oblivion.subreption.com> <20090531001318.093e3665@lxorguk.ukuu.org.uk> <20090530231813.GP6535@oblivion.subreption.com>
In-Reply-To: <20090530231813.GP6535@oblivion.subreption.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry H. wrote:
> OK, I'm going to squeeze some time and provide patches that perform the
> same my original page bit ones did, but using kzfree. Behold code like
> in the tty buffer management, which uses the page allocator directly for
> allocations greater than PAGE_SIZE in length. That needs special
> treatment, and is exactly the reason I've proposed unconditional
> sanitization since the original patches were rejected.

You might want to also do the patch Alan suggested for the security 
conscious people. That is, do a memset() in every page free and wrap 
that under CONFIG_SECURITY_PARANOIA or something. There's no reason the 
kzfree() patches and that can't co-exist.

			Pekka
