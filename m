Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472Ab0A2NiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0A2NiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158Ab0A2NiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:38:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab0A2NiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:38:18 -0500
Date: Fri, 29 Jan 2010 13:38:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Toralf F??rster <toralf.foerster@gmx.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10
	>/dev/null'
Message-ID: <20100129133816.GQ19799@ZenIV.linux.org.uk>
References: <201001212017.00160.toralf.foerster@gmx.de> <2375c9f91001272051x3d2e89r24133c42f52082ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f91001272051x3d2e89r24133c42f52082ea@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 12:51:02PM +0800, Am??rico Wang wrote:
> 2010/1/22 Toralf F??rster <toralf.foerster@gmx.de>:
> > I was inspired by http://article.gmane.org/gmane.linux.kernel/941115 .
> >
> > Running the command (se subject) as a normal user at a 2.6.32.4 kernel
> > gives this in /var/log/messages:
> >
> > 2010-01-21T20:11:39.171+01:00 n22 kernel: head: page allocation failure. order:9, mode:0xd0
> 
> 
> Hmm, it is suspecious that we need 2^9 pages for seq_file...

Something's using single_open() and obscene amounts of output; should
switch to real iterator...  Which file it is?
