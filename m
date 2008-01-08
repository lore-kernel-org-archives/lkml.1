Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYAHKRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYAHKRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYAHKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:17:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:55860 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbYAHKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:17:33 -0500
Date: Tue, 8 Jan 2008 11:17:32 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] udf: replace loops coded with goto to real loops
Message-ID: <20080108101732.GB17794@duck.suse.cz>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com> <1199582513-7915-4-git-send-email-marcin.slusarz@gmail.com> <20080107144821.GK12589@duck.suse.cz> <20080107210955.GC22144@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107210955.GC22144@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-01-08 22:10:01, Marcin Slusarz wrote:
> On Mon, Jan 07, 2008 at 03:48:21PM +0100, Jan Kara wrote:
> > On Sun 06-01-08 02:21:50, marcin.slusarz@gmail.com wrote:
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> >   I'm not sure if this improves readability in general. If the code is
> > really a loop in nature, then we should code it using do {} while but in
> > case we loop back just in case of some error (as seems to be the case in
> > udf_bitmap_new_block()), then IMHO goto is more explanative. So at least
> > that one case I'd leave as is.
> Why do you think it's an error?
  There is code:

          if (!udf_clear_bit(bit, bh->b_data)) {
                udf_debug("bit already cleared for block %d\n", bit);
                goto repeat;
        }
  Now if this happens, it's a bug AFAICS because we have been searching for
a free block and we hold s_alloc_mutex and hence we should not race with
any other allocation.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
