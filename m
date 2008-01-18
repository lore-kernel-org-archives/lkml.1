Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbYARBQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbYARBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbYARBP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:15:56 -0500
Received: from ozlabs.org ([203.10.76.45]:46853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbYARBPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:15:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove vfs_init_caches_early()
Date: Fri, 18 Jan 2008 12:15:19 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Paul Mackerras <paulus@samba.org>
References: <200801181041.22157.rusty@rustcorp.com.au>
In-Reply-To: <200801181041.22157.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181215.20491.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 10:41:21 Rusty Russell wrote:
> vfs_init_caches_early() does nothing on IA-64 and x86-64 (unless you
> turn off CONFIG_NUMA): hashdist is set by default on these platforms.
>
> Maybe some obscure feature which requires VFS to be set up v. early
> (hence is broken in this configuration), or something arch-specific
> (which seems unlikely).  Most likely this is a relic.
>
> Unless someone has inside knowledge, the easiest way to find out is to
> rip it out and see if anyone screams.  Boots fine on my 32-bit x86 box
> here.

Ok, Chris Wright pointed me to the justification: it was because on 64G 
powerpc machines, MAX_ORDER of 11 was too small to allocate sufficient 
hashes.

See 
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=50c2cb5183e4f101f923212e39a58a66a530cf77

Since MAX_ORDER is now 13 on powerpc, I think we're good.

Thanks Cdub!
Rusty.
