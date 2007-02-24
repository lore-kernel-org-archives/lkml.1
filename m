Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbXBXW4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbXBXW4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXBXW4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:56:45 -0500
Received: from holomorphy.com ([66.93.40.71]:48721 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576AbXBXW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:56:44 -0500
Date: Sat, 24 Feb 2007 14:56:31 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224225631.GA9222@holomorphy.com>
References: <20070223153743.GA26141@wotan.suse.de> <20070224042444.GU21484@holomorphy.com> <20070224050937.GA16601@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224050937.GA16601@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 08:24:44PM -0800, William Lee Irwin III wrote:
>> You would be better served by a data structure different from a hashtable.

On Sat, Feb 24, 2007 at 06:09:37AM +0100, Nick Piggin wrote:
> Out of curiosity, what better data structure do you have in mind for
> the dentry hash?

Per-directory indices of ->d_subdirs. Hash tries (spelled correctly)
and B+ trees hung off dentries corresponding to directories are
plausible. There are plenty of other possibilities; just do it on a
per-directory basis so you don't intermix children of different parents
in some boot-time -allocated global trainwreck and you're home free.
Benchmarking is probably needed to gauge which performs best.


-- wli
