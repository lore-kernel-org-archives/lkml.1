Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbYEEV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbYEEV6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbYEEV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:58:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759248AbYEEV6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:58:09 -0400
Date: Mon, 5 May 2008 14:58:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] lib: add ascii hex helper functions
Message-Id: <20080505145807.da846236.akpm@linux-foundation.org>
In-Reply-To: <1209842847.26173.122.camel@brick>
References: <1209842847.26173.122.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 May 2008 12:27:27 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Everyone rolls their own version around the tree, centralize
> in lib/hexdump.c.  Move the only existing users of hex_asc over
> to the hi/lo helpers.
> 
> Add helpers for reading binary values from a stream of hex chars.
> Most existing users want to know how many chars were read as well.
> This implementation chooses to return the number of chars read
> and takes a pointer to the value being read.
> 
> As an alternative, a char **buf could be passed and the value could
> be returned and the pointer updated by reference.
> 
> Fixed size helpers for u8, u16, u32 and u64 have been added with
> another helper that takes an argument specifying the max number of
> chars to read (capped to the size that will fit in an unsigned long)
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, I've thought a little more about this, It's possible we could
> get away without the u8/u16 helpers, but it does make the api nicely
> complete, and they are pretty small.  Most users really want to read
> a long or an int, but many can be move to the u32/u64 versions to
> tighten up implicit assumptions being made about the length being
> read.

hex_to_val() is distressingly similar to simple_strtoul(..., ..., 16).

> I'll wait for coment before fixing the previous series of patches to
> use these.

I'm all worn out on this one.
