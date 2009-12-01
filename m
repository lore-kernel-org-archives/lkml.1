Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZLAOAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZLAOAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZLAOAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:00:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47445 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZLAOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:00:36 -0500
Date: Tue, 1 Dec 2009 07:00:41 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Liuweni <qingshenlwy@gmail.com>
Cc: strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>, viro <viro@zeniv.linux.org.uk>,
       akpm <akpm@linux-foundation.org>, jack <jack@suse.cz>,
       npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091201140041.GW9482@parisc-linux.org>
References: <20091201120337.GV9482@parisc-linux.org> <200912012115341872867@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912012115341872867@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 09:21:32PM +0800, Liuweni wrote:
> Hi Matthew Wilcox:
> 	I got the code note as the following. if there is no performance problem, 
> maybe the code note need update.
> 
> 
> ------
>  *	BUGS:
>  *	With a large number of inodes live on the file system this function
>  *	currently becomes quite slow.
> 

I don't believe that comment is correct.  In any case, your optimisation
wouldn't make a lick of difference to the speed; it's a single comparison
in a loop which also calculates a hash, makes a function call, and walks
the length of a hash chain.

The old adage about debugging code, not comments applies here.  Don't take
somebody else's word for it that there's a performance problem here.
Devise a test to demonstrate the performance problem.  Otherwise, how
will you know if you solved it?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
