Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYDKKlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYDKKlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbYDKKlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:41:37 -0400
Received: from lazybastard.de ([212.112.238.170]:57019 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbYDKKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:41:36 -0400
Date: Fri, 11 Apr 2008 12:41:28 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 4/15] fs/logfs/compr.c
Message-ID: <20080411104128.GG25462@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080401181332.853833004@logfs.org> <200804101613.48465.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804101613.48465.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 April 2008 16:13:47 +0200, Arnd Bergmann wrote:
> 
> How much time is spent in the compression code? Would it be helpful
> to have a percpu stream and do preempt_disable around it instead
> of the mutex?
> 
> That would improve parallelism and cache-locality of the compression,
> at the cost of adding a source of latency to preemptible kernels.

Several years back (before logfs) I was planning to do just that.  It
turned out that ipsec doesn't work in such a fashion, because each
connection is a stream.  And the two block-oriented users, jffs2 and
cramfs just weren't worth it.

Might be a good idea by now.  I guess it should become self-contained
code, so that jffs2, cramfs and ubifs can use it as well.

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
