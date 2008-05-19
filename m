Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYESFz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYESFz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYESFzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:55:18 -0400
Received: from verein.lst.de ([213.95.11.210]:60098 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYESFzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:55:17 -0400
Date: Mon, 19 May 2008 07:55:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] ERR_PTR: add ERR_OR_0_PTR
Message-ID: <20080519055504.GB14902@lst.de>
References: <20080513201813.GA5869@joi> <1211148067-16130-1-git-send-email-marcin.slusarz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211148067-16130-1-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 12:01:07AM +0200, Marcin Slusarz wrote:
> Some codepaths call ERR_PTR with possibly 0 argument, which is not
> a valid errno and rely on conversion from 0 to NULL pointer.
> Add ERR_OR_0_PTR function which accepts errnos and 0 as an argument.

Sorry, no.  ERR_PTR(0) is perfectly valid, you just don't want to return
the actualy value.  E.g. we have a common idiom of:

	some_ptr = ERR_PTR(err);
	if (IS_ERR(some_ptr))
		goto out_handle_err;

and obsfucating this with new syntactic sugar is not a good idea.

