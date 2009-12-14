Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZLNQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZLNQa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZLNQaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:30:24 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42458 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZLNQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:30:22 -0500
Date: Mon, 14 Dec 2009 09:30:19 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Emese Revfy <re.emese@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
	2.6.32-git-053fe57ac v2
Message-ID: <20091214163019.GG7812@parisc-linux.org>
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org> <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com> <20091214112656.GB1959@elf.ucw.cz> <20091214080049.19930729@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214080049.19930729@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 08:00:49AM -0800, Arjan van de Ven wrote:
> I for one am not opposed to using const where we could be using const.
> It's a fundamental language feature, that helps the compiler and
> developer. Yes there is sparse, and no, almost nobody uses that.
> 
> If it's const, it won't be and can't be changed, allowing
> more aggressive optimization. It also means all these structures get
> put in the rodata section, which means by definition they can no longer
> have false sharing with data structures that are written to,.. and that
> section is often even really read only (cpu protection bits), which is
> also a nice, but secundary; _ops are one of those targets for rootkits
> and accidental overwrites.

Yes, but that's accomplished by tagging each of the arrays of function
pointers in question as const.  Not by tagging the individual members
within the structure definition as const, which is what this patch
series does.

I don't think anyone objects to what you're trying to accomplish, but
this series of patches, as Al says, feel like pure cargo-culting.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
