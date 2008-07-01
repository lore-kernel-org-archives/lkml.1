Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYGAIKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYGAIKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYGAIKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:10:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYGAIK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:10:29 -0400
Date: Tue, 1 Jul 2008 04:10:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080701081026.GB16691@infradead.org>
References: <20080630212450t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630212450t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still disagree with this whole patch.  There is not reason to let
the freeze request timeout - an auto-unfreezing will only confuse the
hell out of the caller.  The only reason where the current XFS freeze
call can hang and this would be theoretically useful is when the
filesystem is already frozen by someone else, but this should be fixed
by refusing to do the second freeze, as suggested in my comment to patch
1.

