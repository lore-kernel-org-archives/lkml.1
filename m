Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYKSP0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYKSP0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYKSP0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:26:24 -0500
Received: from styx.suse.cz ([82.119.242.94]:47082 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751929AbYKSP0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:26:23 -0500
Date: Wed, 19 Nov 2008 16:26:22 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] udf: reduce stack usage of udf_get_filename
Message-ID: <20081119152622.GB29820@duck.suse.cz>
References: <20081116180240.GB6282@joi> <20081118161938.e415c6bc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118161938.e415c6bc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-11-08 16:19:38, Andrew Morton wrote:
> On Sun, 16 Nov 2008 19:02:45 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > +	filename = kmalloc(sizeof(struct ustr), GFP_NOFS);
> 
> I suspect that we could have used the superior GFP_KERNEL everywhere in
> both these patches.  But I'll let Jan worry about that ;)
  Definitely not in the second case - that one is called from inside
readdir, lookup and symlink resolution code so that could lead to deadlocks
IMHO.
  Regarding the first case in process_sequence, that is called only from
udf_fill_super(). So there it might be safe to use GFP_KERNEL but I'm not
quite sure either... So I'd leave GFP_NOFS there.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
