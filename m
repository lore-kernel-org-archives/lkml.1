Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXHUBzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXHUBzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 21:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXHUBzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 21:55:08 -0400
Received: from main.gmane.org ([80.91.229.2]:43250 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXHUBzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 21:55:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Salah Coronya <salah.coronya@gmail.com>
Subject: Re: NFS hang + umount -f: better behaviour requested.
Date: Tue, 21 Aug 2007 01:51:58 +0000 (UTC)
Message-ID: <loom.20070821T034654-315@post.gmane.org>
References: <20070820225415.GL3956@digitalkingdom.org> <18122.9034.504690.370294@notabene.brown> <20070820233414.GM3956@digitalkingdom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 206.126.170.20 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Lee Powell <rlpowell <at> digitalkingdom.org> writes:


> > Though I agree that it would be nice if we could convince all
> > subsequent requests to a server to fail EIO instead of just the
> > currently active ones.  I'm not sure that just changing "umount
> > -f" is the right interface though....  Maybe if all the server
> > handles appeared in sysfs and have an attribute which you could
> > set to cause all requests to fail...
> 
> I have no opinion on interface details, I simply know that on
> Solaris, "umount -f" Just Works, and I would love to have similar
> behaviour on Linux.
> 
> -Robin
> 

What you are looing is revoke()/frevokeat(); which will yank the file right from
under the descriptor. Its currently in -mm. Of course "mount" will still need to
iterate over each open file on the mount and revoke it.



