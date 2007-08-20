Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXHTXe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXHTXe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXHTXeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:34:20 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:55064 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXHTXeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:34:19 -0400
Date: Mon, 20 Aug 2007 16:34:14 -0700
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070820233414.GM3956@digitalkingdom.org>
References: <20070820225415.GL3956@digitalkingdom.org> <18122.9034.504690.370294@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18122.9034.504690.370294@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 09:27:06AM +1000, Neil Brown wrote:
> On Monday August 20, rlpowell@digitalkingdom.org wrote:
> > (cc's to me appreciated)
> > 
> > It would be really, really nice if "umount -f" against a hung
> > NFS mount actually worked on Linux.  As much as I hate Solaris,
> > I consider it the gold standard in this case: If I say "umount
> > -f /mount/that/is/hung" it just goes away, immediately, and
> > anything still trying to use it dies (with EIO, I'm told).
> 
> Have you tried "umount -l"?   How far is that from your
> requirements?

I actually talked about that further down.  The short version: quite
far.

The long version:

It leaves a bunch of hung processes, with no real way for me to
determine which processes are hung on the now-non-existent mount,
and (at least with autofs) it leaves /etc/mtab in an inconsistent
state, so I had to edit it to restart autofs.  Only a mild
improvement on rebooting, says I.

Also, it took a really long time (minutes) to return.

> Alternately:
>    mount --move /problem/path /somewhere/else
>    umount -f /somewhere/else
>    umount -l /somewhere/else
> 
> might be a little closer to what you want.

I don't think that would solve the problem: the umount -f would
still hang and eventually return busy, fuser would still hang, and
umount -l would still leave inconsistent crap lying around.

> Though I agree that it would be nice if we could convince all
> subsequent requests to a server to fail EIO instead of just the
> currently active ones.  I'm not sure that just changing "umount
> -f" is the right interface though....  Maybe if all the server
> handles appeared in sysfs and have an attribute which you could
> set to cause all requests to fail...

I have no opinion on interface details, I simply know that on
Solaris, "umount -f" Just Works, and I would love to have similar
behaviour on Linux.

-Robin

-- 
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
Reason #237 To Learn Lojban: "Homonyms: Their Grate!"
Proud Supporter of the Singularity Institute - http://singinst.org/
