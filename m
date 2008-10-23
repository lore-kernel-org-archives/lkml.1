Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYJWT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYJWT0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYJWT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:26:37 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35180 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYJWT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:26:36 -0400
Date: Thu, 23 Oct 2008 13:26:18 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned	htree
 hash algorithms
In-reply-to: <20081023025646.GD10369@mit.edu>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20081023192618.GS3184@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1224560624-9691-1-git-send-email-tytso@mit.edu>
 <1224560624-9691-2-git-send-email-tytso@mit.edu>
 <20081022172221.c1a8c5b5.akpm@linux-foundation.org>
 <20081023025646.GD10369@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 22, 2008  22:56 -0400, Theodore Ts'o wrote:
> On Wed, Oct 22, 2008 at 05:22:21PM -0700, Andrew Morton wrote:
> > arm says
> > 
> > fs/ext3/super.c: In function `ext3_fill_super':
> > fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type
> > 
> > Also, is there any way in which this new code can be, umm, cleaned up?
> 
> Hmm..... is it considered safe to depend on the userspace limits.h
> header file?  I guess if we trust that header file to be correct we
> could check the value of CHAR_MIN and/or CHAR_MAX as defined by
> limits.h.

That would likely fail on cross-compiled environments, right?

> Alternatively we could do an #ifdef __CHAR_UNSIGNED__, which is
> defined by gcc.  The manual for gcc tells us not to depend on it, but
> to depend on limits.h instead.

This warning likely is aimed at userspace for portable applications.

> Any thoughts, or comments?  Does anyone know if the Intel compiler
> will DTRT with either of these approaches?

If it doesn't, then it probably has some equivalent that can be #ifdef'd
in its place.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

