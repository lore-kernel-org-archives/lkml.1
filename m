Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYH0WRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYH0WRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYH0WRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:17:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33678 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYH0WRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:17:14 -0400
Date: Wed, 27 Aug 2008 23:17:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: C language lawyers needed
Message-ID: <20080827221711.GE28946@ZenIV.linux.org.uk>
References: <adaod3ef82e.fsf@cisco.com> <48B5CE61.8020809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B5CE61.8020809@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 03:00:01PM -0700, H. Peter Anvin wrote:
> Looks like a gcc bug to me.
>
> 0xff000000 is unsigned, like any hexadecimal constant.

Not any.  Ones that do not fit into range of int but do fit into the range
of unsigned are.

Really, folks, it's not _that_ hard:

Type sequence: int, unsigned int, long, unsigned long, long long,
unsigned long long.
With U suffix => don't bother with signed types
Without U suffix, decimal => don't bother with _un_signed types
With L suffix => don't bother with anything earlier than long
With LL suffix => don't bother with anything earlier than long long
Pick the first type that covers your value; that will be it.

In particular, 0x[0-9A-Fa-f]+ == try *everything*.
