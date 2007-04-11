Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXDKOpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXDKOpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXDKOp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:45:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50346 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbXDKOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:45:20 -0400
Date: Wed, 11 Apr 2007 09:45:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Ian Kent <raven@themaw.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hpa@zytor.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
Message-ID: <20070411144517.GA27705@sergelap.austin.ibm.com>
References: <20070404183012.429274832@szeredi.hu> <20070406160238.f3178189.akpm@linux-foundation.org> <4616D4D4.6020405@zytor.com> <1176195125.3476.47.camel@raven.themaw.net> <E1HbaNO-0005AV-00@dorka.pomaz.szeredi.hu> <1176299311.3377.6.camel@raven.themaw.net> <20070411142608.GC30460@sergelap.austin.ibm.com> <1176301632.3377.9.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176301632.3377.9.camel@raven.themaw.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ian Kent (raven@themaw.net):
> On Wed, 2007-04-11 at 09:26 -0500, Serge E. Hallyn wrote:
> > Quoting Ian Kent (raven@themaw.net):
> > > On Wed, 2007-04-11 at 12:48 +0200, Miklos Szeredi wrote:
> > > > > > >>
> > > > > > >> - users can use bind mounts without having to pre-configure them in
> > > > > > >>   /etc/fstab
> > > > > > >>
> > > > > > 
> > > > > > This is by far the biggest concern I see.  I think the security 
> > > > > > implication of allowing anyone to do bind mounts are poorly understood.
> > > > > 
> > > > > And especially so since there is no way for a filesystem module to veto
> > > > > such requests.
> > > > 
> > > > The filesystem can't veto initial mounts based on destination either.
> > > > I don't think it's up to the filesystem to police bind/move mounts in
> > > > any way.
> > > 
> > > But if a filesystem can't or the developer thinks that it shouldn't for
> > > some reason, support bind/move mounts then there should be a way for the
> > 
> > Can you list some valid reasons why an fs could care where it is
> > mounted?  The only thing I could think of is a stackable fs, but it
> > shouldn't care whether it is overlay-mounted or not.
> 
> For my part, autofs and autofs4.

Ah, thanks.

I can see I'm going to have start using autofs to get to know the
implementation, because it seems clear we'll run into it in the
containers work again (beyond the struct pid conv) at some point.

> Moving or binding isn't valid.
> I tried to design that limitation out version 5 but wasn't able to.
> In time I probably can but couldn't continue to support older versions.

thanks,
-serge

> > 
> > thanks,
> > -serge
> > 
> > > filesystem to tell the kernel that.
> > > 
> > > Surely a filesystem is in a good position to be able to decide if a
> > > mount request "for it" should be allowed to continue based on it's "own
> > > situation and capabilities".
> > > 
> > > Ian
> > > 
> > > 
> > > 
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
