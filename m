Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYH0STf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYH0STf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYH0STR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:19:17 -0400
Received: from lazybastard.de ([212.112.238.170]:58455 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYH0STQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:19:16 -0400
Date: Wed, 27 Aug 2008 20:19:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080827181904.GD1371@logfs.org>
References: <20080826101618.GA17261@logfs.org> <200808261654.AA00216@capsicum.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808261654.AA00216@capsicum.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 August 2008 01:54:30 +0900, Ryusuke Konishi wrote:
> On Tue, 26 Aug 2008 12:16:19 +0200, Jorn Engel wrote:
> >
> >Interesting approach.  Does that mean that every block lookup involves
> >two disk accesses, one for the DAT and one for the actual block?
> 
> Simply stated, it's Yes.
> 
> But the actual number of disk accesses will become fewer because the DAT is 
> cached like regular files and read-ahead is also applied.
> The cache for the DAT works well enough.

Yep.  It is not a bad tradeoff.  You pay with some extra seeks when the
filesystem is freshly mounted but gain a lot of simplicity in garbage
collection.

More questions.  I believe the first two answer are no, but would like
to be sure.
Do you support compression?
Do you do wear leveling or scrubbing?
How does garbage collection work?  In particular, when the filesystem
runs out of free space, do you depend on the userspace daemon to make
some policy decisions or can the kernel make progress on its own?

Jörn

-- 
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
