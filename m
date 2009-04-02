Return-Path: <linux-kernel-owner+w=401wt.eu-S1762360AbZDBPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360AbZDBPLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZDBPLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:11:35 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63611 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZDBPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PTvxN6Gk7TqkV9TbfYlRZPd9urTt+fiRNTSuGgfTCzobSvnJHJQzUraqqSQ5rCUMq7
         B2nvyoLu6hoQUHmbAHPgAUb7f87yH/j2BWuJRRoKGYrJNG9E3P0AsY9ztVZjD06hdyLw
         NvpgbkVTjWmJdA0vTXuotcDIZKPs5kHKPAXOk=
Date: Thu, 2 Apr 2009 18:10:21 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402151020.GB1986@dhcp-1-124.tlv.redhat.com>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904022243.21088.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:43:19PM +1030, Rusty Russell wrote:
> On Thursday 02 April 2009 21:36:07 Gregory Haskins wrote:
> > You do not need to know when the packet is copied (which I currently
> > do).  You only need it for zero-copy (of which I would like to support,
> > but as I understand it there are problems with the reliability of proper
> > callback (i.e. skb->destructor).
> 
> But if you have a UP guest, there will *never* be another packet in the queue
> at this point, since it wasn't running.
> 
> As Avi said, you can do the processing in another thread and go back to the
> guest; lguest pre-virtio did a hacky "weak" wakeup to ensure the guest ran
> again before the thread did for exactly this kind of reason.
> 
> While Avi's point about a "powerful enough userspace API" is probably valid,
> I don't think it's going to happen.  It's almost certainly less code to put a
> virtio_net server in the kernel, than it is to create such a powerful
> interface (see vringfd & tap).  And that interface would have one user in
> practice.
> 
> So, let's roll out a kernel virtio_net server.  Anyone?
> Rusty.

BTW, whatever approach is chosen, to enable zero-copy transmits, it seems that
we still must add tracking of when the skb has actually been transmitted, right?

Rusty, I think this is what you did in your patch from 2008 to add destructor
for skb data ( http://kerneltrap.org/mailarchive/linux-netdev/2008/4/18/1464944 ):
and it seems that it would make zero-copy possible - or was there some problem with
that approach? Do you happen to remember?

-- 
MST
