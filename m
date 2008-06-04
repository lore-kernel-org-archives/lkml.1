Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbYFDKT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbYFDKT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbYFDKTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:19:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:53035 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758770AbYFDKT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:19:26 -0400
Date: Wed, 4 Jun 2008 12:19:25 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
	buffers
Message-ID: <20080604101925.GB16572@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com> <20080603153050.fb99ac8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603153050.fb99ac8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-06-08 15:30:50, Andrew Morton wrote:
> On Mon, 02 Jun 2008 19:43:57 +0900
> Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> 
> > 
> > In ordered mode, we should abort journaling when an I/O error has
> > occurred on a file data buffer in the committing transaction.
> 
> Why should we do that?
  I see two reasons:
1) If fs below us is returning IO errors, we don't really know how severe
it is so it's safest to stop accepting writes. Also user notices the
problem early this way. I agree that with the growing size of disks and
thus probability of seeing IO error, we should probably think of something
cleverer than this but aborting seems better than just doing nothing.

2) If the IO error is just transient (i.e., link to NAS is disconnected for
a while), we would silently break ordering mode guarantees (user could be
able to see old / uninitialized data).

								Honza

PS: Changed Andreas's address in the email to the new one...
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
