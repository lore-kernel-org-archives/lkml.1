Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbZFQLtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbZFQLtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZFQLtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:49:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:53299 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZFQLtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:49:42 -0400
Date: Wed, 17 Jun 2009 13:49:43 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/11] ext3: Get rid of extenddisksize parameter of
	ext3_get_blocks_handle()
Message-ID: <20090617114943.GC2612@duck.suse.cz>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <1245088797-29533-2-git-send-email-jack@suse.cz> <20090617102810.GA29931@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617102810.GA29931@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17-06-09 12:28:10, Nick Piggin wrote:
> On Mon, Jun 15, 2009 at 07:59:48PM +0200, Jan Kara wrote:
> > Get rid of extenddisksize parameter of ext3_get_blocks_handle(). This seems to
> > be a relict from some old days and setting disksize in this function does not
> > make much sence. Currently it was set only by ext3_getblk().  Since the
> > parameter has some effect only if create == 1, it is easy to check that the
> > three callers which end up calling ext3_getblk() with create == 1 (ext3_append,
> > ext3_quota_write, ext3_mkdir) do the right thing and set disksize themselves.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I guess something like this should just go in this merge window if
> ext3 developers are happy with it? There is no real reason to keep
> it with the main patchset is there?
  Yes, I'll merge this separately. It's in the series just because ext3
patches depend on it.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
