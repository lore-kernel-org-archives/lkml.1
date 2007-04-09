Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXDIUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXDIUMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXDIUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:12:31 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:40148 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513AbXDIUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:12:29 -0400
To: serue@us.ibm.com
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxram@us.ibm.com
In-reply-to: <20070409170743.GF24415@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu> <20070406160238.f3178189.akpm@linux-foundation.org> <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu> <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com>
Message-Id: <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 09 Apr 2007 22:10:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The one in pam-0.99.6.3-29.1 in opensuse-10.2 is totally broken.  Are
> > you interested in the details?  I can reproduce it, but forgot to note
> > down the details of the brokenness.
> 
> I don't know how far removed that is from the one being used by redhat,
> but assuming it's the same, then redhat-lspp@redhat.com will be
> very interested.

OK.

> >  - user namespace setup: what if user has multiple sessions?
> > 
> >    1) namespaces are shared?  That's tricky because the session needs to
> >    be a child of a namespace server, not of login.  I'm not sure PAM
> >    can handle this
> > 
> >    2) or mounts are copied on login?  That's not possible currently,
> >    as there's no way to send a mount between namespaces.  Also it's
> >    tricky to make sure that new mounts are also shared
> 
> See toward the end of the 'shared subtrees' OLS paper from last year for
> a suggestion on how to let users effectively 'log in to' an existing
> private mounts ns.

This?

  1. create a new namespace
  2. bind /share/$USER to /share
  3. for each pair ($who, $what) such that
     /share/$USER/$who/$what exists, look
     in /share/$who/allowed for "peer $what
     $USER" or "slave $what $USER". If the
     former is found, rbind /share/$who/$what
     on /share/$USER/$who/$what; if the
     latter is found, do the same and
     follow with marking subtree under
     /share/$USER/$who/$what as slave.
  4. rbind /share/$USER to /share
  5. mark subtree under /share as private.
  6. umount -l /share

Well, someone please explain using short words, because I don't
understand at all.

Thanks,
Miklos
