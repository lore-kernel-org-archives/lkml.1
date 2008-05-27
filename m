Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYE0Egc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYE0Egc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYE0EgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:36:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49799 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYE0EgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:36:23 -0400
Date: Mon, 26 May 2008 20:52:41 -0700
From: Greg KH <greg@kroah.com>
To: James Morris <jmorris@namei.org>
Cc: Markku Savela <msa@moth.iki.fi>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Bug/misfeature of "securityfs"
Message-ID: <20080527035241.GB20295@kroah.com>
References: <87iqx1pd24.fsf@burp.tkv.asdf.org> <Xine.LNX.4.64.0805271019550.17391@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0805271019550.17391@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:20:17AM +1000, James Morris wrote:
> On Mon, 26 May 2008, Markku Savela wrote:
> 
> > 
> > I write a module which creates a securityfs on init
> > 
> >   foobar =  securityfs_create_dir("foobar", NULL)
> > and on exit it does
> >   security_fs_remove(foobar);
> > 
> > When I do "insmod" and "rmmod", I see
> > 
> >   /sys/kernel/security/foobar/
> > 
> > appear and go away.
> > 
> > Now, if have a shell and do "cd /sys/kernel/security/foobar", the
> > "rmmod" does not remove the directory. The directory disappears when I
> > exit the shell from it via "cd ..". This is fine, and as it should be,
> > but....
> > 
> > IF, while having the shell in the directory, I try to "insmod" again,
> > the insmod fails with "-1 File exists". Again, understandable, BUT
> > when after this I exit the shell from the directory, IT DOES NOT GO
> > AWAY. It's permanetly existing, and module install fails always with
> > "File Exists".
> > 
> > Is this a bug, or am doing something wrong?

Yeah, the whole sequence above is "wrong" :)

How is the file always sticking around?  Can you still see it in other
shells?  Is a process still located there somehow?

securityfs is just using libfs for all of this, there shouldn't be any
problem here, unless it is also present there.

Or maybe we aren't cleaning up properly on the "file exists" code path?
Care to look into that?

thanks,

greg k-h
