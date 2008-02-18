Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYBRHEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYBRHEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYBRHEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:04:44 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52426 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYBRHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:04:43 -0500
Date: Mon, 18 Feb 2008 00:04:39 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
In-reply-to: <20080217081935.GN3848@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <20080218070439.GG3029@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080217081935.GN3848@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008  10:19 +0200, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make the following needlessly global function static:
>   - journal_check_used_features()
> - remove the following unused EXPORT_SYMBOL's:
>   - journal_set_features
>   - journal_update_superblock

Nack.  I don't object to un-exporting journal_update_superblock(), because
that is pretty internal, but the other functions are intended specifically
for use by code outside of JBD.  For example, the journal checksum patch for
ext3/4 uses journal_set_features() to turn on features in the JBD superblock.

Similarly, for 64-bit support in ext4 uses journal_set_features() to set
a 64-bit feature flag in the journal superblock.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

