Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYH0P4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYH0P4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYH0P4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:56:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37935 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYH0P4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:56:36 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080827153628.GA11242@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu> <20080807222751.GA28412@us.ibm.com> <m1prokgyje.fsf@frodo.ebiederm.org> <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com>
Message-Id: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 27 Aug 2008 17:55:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Serge E. Hallyn wrote:
> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Serge, thanks for spotting this: it looks indeed a nasty hole!  I also
> > agree about the solution.
> 
> Are you implementing it, or did you want me to?

I'll implement it.

> > But yeah, we should think this over very carefully.  Especially
> > interaction with mount propagation, which has very complicated and
> > sometimes rather counter-intuitive semantics.
> 
> I know we discussed before about whether a propagated mount from a
> non-user mount to a user mount should end up being owned by the user
> or not.  I don't recall (and am not checking the code at the moment
> as your tree is sitting elsewhere) whether we mark the propagated
> tree with the right nosuid and nodev flags, or whether we call it
> a user mount or not.

If the destination is a user mount, then

 - the propagated mount(s) will be owned by the same user as the destination
 - the propagated mount(s) will inherit 'nosuid' from the destination

I remember also thinking about 'nodev' and why it doesn't need similar
treatment to 'nosuid'.  The reasoning was that 'nodev' is safe as long
as permissions are enforced, namespace shuffling cannot make it
insecure.  Does that sound correct?

Thanks,
Miklos
