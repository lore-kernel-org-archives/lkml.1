Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYKQQF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYKQQF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYKQQFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:05:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYKQQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:05:17 -0500
Date: Mon, 17 Nov 2008 11:05:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20081117160515.GA25459@infradead.org>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com> <9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 10:47:12PM -0500, Mimi Zohar wrote:
> This version resolves the merge issues resulting from the removal
> of the nameidata parameter to inode_permission(), by moving the
> integrity_inode_permission() call from inode_permission() to
> may_open(), and renaming the hook to integrity_nameidata_check().

Still neither a good parameter nor a good name.  If you look at fsdevel
you'll see that a patch for the next merged window is already out and
in Al's to be applied queue that removes the nameidata there.  A
strcut path and maybe the MAY_ lookup flags should be enough for you,
and a integrity_path_check also sounds like it really does what you
want.

Also please merge the last radix tree patch into this one so tat it's
possible to review the code that actually goes in instead of replacing
a large part of it in a follow-up patch.

