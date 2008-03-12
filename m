Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYCLCnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYCLCnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYCLCmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:42:50 -0400
Received: from kumera.dghda.com ([80.68.90.171]:4769 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbYCLCmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:42:49 -0400
From: "Duane Griffin" <duaneg@dghda.com>
Date: Wed, 12 Mar 2008 02:42:46 +0000
To: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger@sun.com>, Duane Griffin <duaneg@dghda.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting
	a dirty read-only filesystem
Message-ID: <20080312024246.GB21711@dastardly.plus.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com> <20080306071734.GN3616@webber.adilger.int> <20080311151122.GD6544@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311151122.GD6544@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 04:11:23PM +0100, Jan Kara wrote:
>   Actually, this is nastier than it looks - currently fs, asks
> ext3_sb_getblk() for block 'a' and it gets buffer head with b_blocknr == 'b'
> instead.

Note that it will be a different device as well, in the case of an
external journal.

> So when remounting you'd have to rewrite these buffers with
> original block numbers which is not really possible. So I think
> remapping will have to be solved differently, like providing buffer
> head with correct b_blocknr but taking care when reading data to it and
> reading them from elsewhere. Actually, this has to be done anyway
> because JBD escapes data in the journal and you have to do unescaping
> when reading data...

Hmm, I'll think about this and try to get something working. As a quick
proof-of-concept hack, getting both buffers then overwriting the fs
block's data with the unescaped journal data should do the trick, right?

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
