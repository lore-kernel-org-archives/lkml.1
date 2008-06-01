Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYFAUpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYFAUpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYFAUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:45:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42968 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYFAUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:45:35 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <20080531082934.GG24135@infradead.org> (message from Christoph
	Hellwig on Sat, 31 May 2008 04:29:34 -0400)
Subject: Re: [patch 8/8] vfs: create file_remove_suid() helper
References: <20080529113245.450308367@szeredi.hu> <20080529113318.257547449@szeredi.hu> <20080531082934.GG24135@infradead.org>
Message-Id: <E1K2uQk-0001dO-G7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 01 Jun 2008 22:45:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > All calls to remove_suid() are made with a file pointer.  This is not
> > accidental: similarly to file_update_time(), this function is called
> > when the file is written.
> > 
> > So simplify callers by passing the file pointer instead of the dentry.
> 
> It's not simplifying anything at all.

Yes it is, read the sentence carefully.

>  You just move the pointer
> derefence down one step the callchain without any need.

Which means, that that pointer dereference will be done once instead
of in each caller, no?  It's a gain (albeit a small one) is in code
cleanliness, and possibly in generated code size.

Miklos
