Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXIYXYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXIYXYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXIYXYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:24:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34628 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbXIYXYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:24:47 -0400
Subject: Re: missing mnt_drop_write() on open error
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 16:24:35 -0700
Message-Id: <1190762675.26982.320.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 01:14 +0200, Miklos Szeredi wrote:
> I get this at umount, if there was a failed open():
> 
> WARNING: at fs/namespace.c:586 __mntput()
> 
> I think the problem is that may_open() calls mnt_want_write(), but if
> open doesn't succeed, mnt_drop_write() will not be called.

I see what you're talking about, and it does look like a bug to me.  I'm
working on establishing where the 'struct file' gets created in relation
to all of this, and where best we should back out the write count.

I should have a patch in a few.

-- Dave

