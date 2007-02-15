Return-Path: <linux-kernel-owner+w=401wt.eu-S964892AbXBODlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbXBODlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 22:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXBODlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 22:41:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964889AbXBODla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 22:41:30 -0500
Date: Wed, 14 Feb 2007 19:41:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Message-Id: <20070214194112.5bec3110.akpm@linux-foundation.org>
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 19:09:38 +0000 David Howells <dhowells@redhat.com> wrote:

> These patches provide a GPG-based kernel module signing facility.  Their use is
> not fully automated within the confines of the kernel build process because it
> needs provision of keys from outside of the kernel before the kernel can be
> compiled.
> 
> The patches are:
> 
>  (1) A cut-down MPI library derived from GPG with error handling added.
> 
>  (2) Permit hash algorithms to hash kernel data defined by a virtual address
>      and a length rather than trying to use scattergather lists (which require
>      struct page pointers to be determined).
> 
>  (3) Add extra information to the per-arch ELF headers to more fully describe
>      the format of the ELF metadata.
> 
>  (4) Add module verification capabilities, including ELF metadata verification.
> 
>  (5) Add a generic DSA signature checker.  Given a SHA1 hash of the data to be
>      verified and a binary blob holding a GPG signature stream, this verifies
>      the signature using a built-in ring of public keys.
> 
>  (6) Add a module signature checker that applies signature checking to modules
>      on module load, checking the signature against the ring of public keys
>      compiled into the kernel.

Grand total:

 77 files changed, 9681 insertions(+), 10 deletions(-)

just to be able to sign modules.

Normally I'd collapse writhing in laughter, but..

> These patches have been in use by RHEL and Fedora kernels for years, and so
> have been thoroughly tested.

so I guess there's an argument for merging them so we can send them back to
you guys.  But there's also an argument to declare all this gunk a
vendor-only thing.  How much pain would that cause?
