Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbXGVOfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbXGVOfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXGVOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:35:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47703 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXGVOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:35:33 -0400
Date: Sun, 22 Jul 2007 15:35:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jacob Avraham <jacoba51-tmp@yahoo.com>
Cc: "'Jan Engelhardt'" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
Message-ID: <20070722143531.GA21668@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0707221506090.15705@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 05:23:22PM +0300, Jacob Avraham wrote:
> > {
> > 	struct mystuff *pd = filp->private_data;
> > 	list_del(&pd->list);
> > 	free(pd);
> > }
> > 
> > Simple as that. *Of course* this requires that the file descriptor remains
> > open. But that should not be a problem, would it?

First of all, that's obviously racy (list manipulations without any
exclusion *or* preventing aforementioned timer running while you do
it).

More important part is that stuff put into your private_data would
better remain valid through the lifetime of opened file.  In particular,
you _can't_ expect that process that had opened the file in question
is still alive.
 
> I ended up implementing my own list (similar to the above), so now the question is more theoretical.
> BTW, does 2.6 has an easy way to get from an inode to all the open fds?

Same situation.
