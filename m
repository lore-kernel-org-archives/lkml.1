Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYEaI2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYEaI2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYEaI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:27:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46853 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYEaI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:27:58 -0400
Date: Sat, 31 May 2008 04:27:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: Re: [patch 6/8] Factor out sysctl pathname code
Message-ID: <20080531082757.GF24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113315.284080903@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113315.284080903@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:51PM +0200, Miklos Szeredi wrote:
> Convert the selinux sysctl pathname computation code into a standalone
> function.

No point bloating core kernel for selinux mess.  And this whole routine
should rather go away rather than moving it to core code.  While doing
pathname based lookup for the label might work for the limited case
of sysctl where there are no symlinks but is a rather dumb idea in
general.  And reconstructing this path from the sysctl tables is twice
as dumb.
