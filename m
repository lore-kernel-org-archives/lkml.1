Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYKDFYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYKDFYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 00:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYKDFYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 00:24:32 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59580 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYKDFYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 00:24:31 -0500
Date: Mon, 03 Nov 2008 22:24:28 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] improve jbd fsync batching
In-reply-to: <20081103122729.60582692.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rwheeler@redhat.com
Message-id: <20081104052428.GP3184@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20081028201614.GA21600@unused.rdu.redhat.com>
 <20081103122729.60582692.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 03, 2008  12:27 -0800, Andrew Morton wrote:
> On Tue, 28 Oct 2008 16:16:15 -0400
> Josef Bacik <jbacik@redhat.com> wrote:
> > +		spin_lock(&journal->j_state_lock);
> > +		commit_time = journal->j_average_commit_time;
> > +		spin_unlock(&journal->j_state_lock);
> 
> OK, the lock is needed on 32-bit machines, I guess.

Should we pessimize the 64-bit performance in that case, for 32-bit
increasingly rare 32-bit platforms?

It might be useful to have a spin_{,un}lock_64bit_word() helper that
evaluates to a no-op on plaforms that don't need a hammer to do an atomic
64-bit update.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

