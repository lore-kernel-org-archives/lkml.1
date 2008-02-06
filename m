Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbYBFXX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbYBFXX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYBFXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:23:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbYBFXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:23:17 -0500
Date: Wed, 6 Feb 2008 15:22:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-Id: <20080206152239.a2352d6d.akpm@linux-foundation.org>
In-Reply-To: <47AA3EAA.9080204@redhat.com>
References: <47AA3126.8090102@redhat.com>
	<20080206143457.03e8741d.akpm@linux-foundation.org>
	<47AA3EAA.9080204@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 17:11:38 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

>  /*
>   * recursively change the type of the mountpoint.
> + * noinline this do_mount helper to save do_mount stack space.
>   */
> -static int do_change_type(struct nameidata *nd, int flag)
> +static noinline int do_change_type(struct nameidata *nd, int flag)

What we could do here is defined a new noinline_because_of_stack_suckiness
and use that.  Reasons:

- self-documenting, so we don't need to comment each site

- can be made a no-op for suitable __GNUC__ values if gcc ever fixes this

- our children we can go through and delete them all when nobody is using
  the offending gcc versions any more.

what thinkest thou?
