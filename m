Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZJLW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZJLW4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZJLW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:56:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7519 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZJLW4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xI7iIve1u4T0SjjaPaDKkxXOD+EGIpRrF//LF4t8bdBdmjH5UKc8hABgfqrMcbaGB8
         3PoNDfFSRWgcHZkbTzQ2jzWtTZRxdgY7f0f8SWcEDzdTlL63ewtG/zbrZTJUC7VOgtjT
         0v0a2tjzGJYgacLKiTwTd0MAL5VvqMu/fnwJM=
Date: Tue, 13 Oct 2009 00:55:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 0/6 RFC] Remove the BKL from sys_execve on various
	architectures
Message-ID: <20091012225522.GC4711@nowhere>
References: <alpine.LFD.2.00.0910130021440.3658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910130021440.3658@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:32:59AM +0200, John Kacur wrote:
> Most of the mainstream architectures such as x86, x86-64 and ppc, do not 
> use the bkl in sys_execve.
> 
> All of the architectures that still use it, look like copy-and-pastes from 
> a time when the mainstream architectures did use it. In addition, all of 
> the call-outs appear to be to generic functions that are safe to use 
> without the bkl. Therefore, I believe it should be safe to simply remove.
> 
> However, the bkl does some surprising things, and I could be wrong. So 
> please have a look at let us know if there is a reason why your 
> architecture does indeed need the bkl in sys_execve.
> 
> Even better, grab the relevant patch and do some testing and report back.
> 
> Thank you in advance.
> 
> John Kacur


They are all build around the same pattern (the same code actually)
that looks pretty safe. I'm perhaps missing something tricky too, but
as far as I can tell:

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

