Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYJIKSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYJIKSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbYJIKS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:18:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbYJIKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:18:28 -0400
Date: Thu, 9 Oct 2008 06:18:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
       dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
       mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20081009101809.GA1319@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net> <20080929143749.GA13286@infradead.org> <48E0EA0B.7000701@sandeen.net> <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 07:12:17PM +0900, Takashi Sato wrote:
> I think we need the timeout for the case someone dirties so much data
> with mmap, hence the freeze process is swapped out and cannot unfreeze.

That is not supposed to happen.  That's why write blocks early on a
frozen filesystem (the shared mmap write path is currently missing the
check, but that's a rather small patch)

