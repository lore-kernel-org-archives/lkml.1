Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXDKO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXDKO3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXDKO3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:29:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36951 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbXDKO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:29:16 -0400
X-Sasl-enc: 5IAL9cHSknjo+q2cEzARxnl63wHSPo/SHuQP4vCMRr/I 1176301755
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ian Kent <raven@themaw.net>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hpa@zytor.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070411142608.GC30460@sergelap.austin.ibm.com>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <4616D4D4.6020405@zytor.com> <1176195125.3476.47.camel@raven.themaw.net>
	 <E1HbaNO-0005AV-00@dorka.pomaz.szeredi.hu>
	 <1176299311.3377.6.camel@raven.themaw.net>
	 <20070411142608.GC30460@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 22:27:12 +0800
Message-Id: <1176301632.3377.9.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 09:26 -0500, Serge E. Hallyn wrote:
> Quoting Ian Kent (raven@themaw.net):
> > On Wed, 2007-04-11 at 12:48 +0200, Miklos Szeredi wrote:
> > > > > >>
> > > > > >> - users can use bind mounts without having to pre-configure them in
> > > > > >>   /etc/fstab
> > > > > >>
> > > > > 
> > > > > This is by far the biggest concern I see.  I think the security 
> > > > > implication of allowing anyone to do bind mounts are poorly understood.
> > > > 
> > > > And especially so since there is no way for a filesystem module to veto
> > > > such requests.
> > > 
> > > The filesystem can't veto initial mounts based on destination either.
> > > I don't think it's up to the filesystem to police bind/move mounts in
> > > any way.
> > 
> > But if a filesystem can't or the developer thinks that it shouldn't for
> > some reason, support bind/move mounts then there should be a way for the
> 
> Can you list some valid reasons why an fs could care where it is
> mounted?  The only thing I could think of is a stackable fs, but it
> shouldn't care whether it is overlay-mounted or not.

For my part, autofs and autofs4.
Moving or binding isn't valid.
I tried to design that limitation out version 5 but wasn't able to.
In time I probably can but couldn't continue to support older versions.

> 
> thanks,
> -serge
> 
> > filesystem to tell the kernel that.
> > 
> > Surely a filesystem is in a good position to be able to decide if a
> > mount request "for it" should be allowed to continue based on it's "own
> > situation and capabilities".
> > 
> > Ian
> > 
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

