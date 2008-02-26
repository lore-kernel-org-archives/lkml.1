Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbYBZOKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbYBZOKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYBZOKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:10:15 -0500
Received: from lazybastard.de ([212.112.238.170]:37740 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbYBZOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:10:12 -0500
Date: Tue, 26 Feb 2008 15:09:25 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226140925.GB20428@lazybastard.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802262016.11297.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 February 2008 20:16:11 +1100, Nick Piggin wrote:
> 
> Yeah, sync_file_range has slightly unusual semantics and introduce
> the new concept, "writeout", to userspace (does "writeout" include
> "in drive cache"? the kernel doesn't think so, but the only way to
> make sync_file_range "safe" is if you do consider it writeout).

If sync_file_range isn't safe, it should get replaced by a noop
implementation.  There really is no point in promising "a little"
safety.

One interesting aspect of this comes with COW filesystems like btrfs or
logfs.  Writing out data pages is not sufficient, because those will get
lost unless their referencing metadata is written as well.  So either we
have to call fsync for those filesystems or add another callback and let
filesystems override the default implementation.

Jörn

-- 
There is no worse hell than that provided by the regrets
for wasted opportunities.
-- Andre-Louis Moreau in Scarabouche
