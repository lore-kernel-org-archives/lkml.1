Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbXHITrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbXHITrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXHITrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:47:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbXHITrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:47:13 -0400
Date: Thu, 9 Aug 2007 12:46:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net,
       akpm@google.com
Subject: Re: [PATCH] unicode diacritics support
Message-Id: <20070809124642.fbbd3e68.akpm@linux-foundation.org>
In-Reply-To: <20070808081010.GA3292@implementation.labri.fr>
References: <20070808081010.GA3292@implementation.labri.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 10:10:10 +0200
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> There have been issues with non-latin1 diacritics and unicode.
> http://bugzilla.kernel.org/show_bug.cgi?id=7746
> 
> Git 759448f459234bfcf34b82471f0dba77a9aca498 `Kernel utf-8 handling'
> partly resolved it by adding conversion between diacritics and
> unicode. The patch below goes further by just turning diacritics into
> unicode, hence providing better future support. The kbd support can be
> fetched from
> http://bugzilla.kernel.org/attachment.cgi?id=12313
> 
> This was tested in all of latin1, latin9, latin2 and unicode with french
> and czech dead keys.
> 
> --
> 
> Turn the kernel accent_table into unicode, and extend ioctls KDGKBDIACR
> and KDSKBDIACR into their equivalents KDGKBDIACRUC and KDSKBDIACR.
> 
> New function int conv_uni_to_8bit(u32 uni) for converting unicode into 8bit
> _input_.  No, we don't want to store the translation, as it is potentially
> sparse and large.

This changes the kernel ABI a bit.  The KDGKBDIACR ioctl (and friends)
now return different data.  What are the implications of this?
