Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYCSUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYCSUha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbYCSTlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:41:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757776AbYCSTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:34 -0400
Date: Tue, 18 Mar 2008 17:04:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, kwc@citi.umich.edu, arunsr@cse.iitk.ac.in,
       dwalsh@redhat.com, linux-security-module@vger.kernel.org,
       dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KEYS: Make the keyring quotas controllable through
 /proc/sys
Message-Id: <20080318170438.e4121982.akpm@linux-foundation.org>
In-Reply-To: <20080313191442.28959.28152.stgit@warthog.procyon.org.uk>
References: <20080313191432.28959.52722.stgit@warthog.procyon.org.uk>
	<20080313191442.28959.28152.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 19:14:42 +0000
David Howells <dhowells@redhat.com> wrote:

> Make the keyring quotas controllable through /proc/sys files:
> 
>  (*) /proc/sys/kernel/keys/root_maxkeys
>      /proc/sys/kernel/keys/root_maxbytes
> 
>      Maximum number of keys that root may have and the maximum total number of
>      bytes of data that root may have stored in those keys.
> 
>  (*) /proc/sys/kernel/keys/maxkeys
>      /proc/sys/kernel/keys/maxbytes
> 
>      Maximum number of keys that each non-root user may have and the maximum
>      total number of bytes of data that each of those users may have stored in
>      their keys.
> 
> Also increase the quotas as a number of people have been complaining that it's
> not big enough.  I'm not sure that it's big enough now either, but on the
> other hand, it can now be set in /etc/sysctl.conf.
> 
> ...
>
>  include/linux/key.h      |    5 +++++
>  kernel/sysctl.c          |    9 +++++++++
>  security/keys/Makefile   |    1 +
>  security/keys/internal.h |   14 ++++++++++----
>  security/keys/key.c      |   23 ++++++++++++++++++-----
>  security/keys/keyctl.c   |   12 +++++++++---
>  security/keys/proc.c     |    9 ++++++---
>  7 files changed, 58 insertions(+), 15 deletions(-)
>
> ...
>
> --- a/security/keys/Makefile
> +++ b/security/keys/Makefile
> @@ -14,3 +14,4 @@ obj-y := \
>  
>  obj-$(CONFIG_KEYS_COMPAT) += compat.o
>  obj-$(CONFIG_PROC_FS) += proc.o
> +obj-$(CONFIG_SYSCTL) += sysctl.o

Could we please have a copy of sysctl.c?  The boring old build system seems
to think it's important.

