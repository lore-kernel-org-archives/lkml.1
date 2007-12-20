Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbXLTNdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbXLTNdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXLTNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:33:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:39476 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753286AbXLTNdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:33:05 -0500
Date: Thu, 20 Dec 2007 14:33:04 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 5/6] udf: fix signedness issue
Message-ID: <20071220133304.GC9125@duck.suse.cz>
References: <20071216021556.GF26986@joi> <20071217163216.GI6979@atrey.karlin.mff.cuni.cz> <20071219192707.GA18305@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219192707.GA18305@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-12-07 20:27:20, Marcin Slusarz wrote:
> On Mon, Dec 17, 2007 at 05:32:17PM +0100, Jan Kara wrote:
> > > sparse generated:
> > > fs/udf/namei.c:896:15: originally declared here
> > > fs/udf/namei.c:1147:41: warning: incorrect type in argument 3 (different signedness)
> > > fs/udf/namei.c:1147:41:    expected int *offset
> > > fs/udf/namei.c:1147:41:    got unsigned int *<noident>
> > > fs/udf/namei.c:1152:78: warning: incorrect type in argument 3 (different signedness)
> > > fs/udf/namei.c:1152:78:    expected int *offset
> > > fs/udf/namei.c:1152:78:    got unsigned int *<noident>
> > >
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> >   I don't think this is right. udf_get_fileident() should take "unsigned
> > int *" as an offset, not just "int". This means changing struct
> > udf_fileident_bh to use unsigned int too but that is better anyway.
> >   And BTW the type shouldn't be uint32_t but really unsigned int in
> > udf_rename (int needn't have 32 bits on all archs (although I think it
> > has currently)).
> That would be hard. Look what is happening with soffset and eoffset
> eg in udf_fileident_read() - these fields are used as signed ints.
  Doh, you're right. soffset can go below 0. OK, then your patch is fine.
You can add there
  Acked-by: Jan Kara <jack@suse.cz>

  BTW: If you haven't got an email from Andrew about accepting the patches
we agreed upon, then please resend the patches to him (with additional
Acked-by: Jan Kara <jack@suse.cz> and CC me) so that they don't get lost.
Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
