Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbXIZQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbXIZQTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXIZQTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:19:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33754 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbXIZQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:19:10 -0400
Subject: Re: missing mnt_drop_write() on open error
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch <hch@infradead.org>
In-Reply-To: <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
	 <1190769669.26982.325.camel@localhost>
	 <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 09:19:05 -0700
Message-Id: <1190823545.30530.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 10:38 +0200, Miklos Szeredi wrote:
> In __dentry_open() there's still a few places where fput() won't be
> called, notably when ->open fails, which is what I'm triggering I
> think.
> 
> Also even more horrible things can happen because of the
> nd->intent.open.file thing.  For example if the lookup routine calls
> lookup_instantiate_filp(), and after this, but before may_open() some
> error happens, then release_open_intent() will call fput() on the
> file, which will cause mnt_drop_write() to be called, even though a
> matching mnt_want_write() hasn't yet been called.  Ugly, eh? 

I'm not sure it is _that_ horrible. ;)

Do you see any reason we can't just shadow the
get/put_write_access(inode) calls with mnt_want/drop_write() calls?  I
think they're always matched.

-- Dave

