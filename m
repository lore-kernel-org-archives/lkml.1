Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZFYNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZFYNRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZFYNRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:17:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54305 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbZFYNRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:17:02 -0400
Date: Thu, 25 Jun 2009 16:16:33 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
Message-ID: <20090625131633.GA7221@redhat.com>
References: <20090623150008.GA21059@redhat.com> <4A4184C3.6060503@novell.com> <20090624084901.GB22865@redhat.com> <20090625110812.GA6487@redhat.com> <4A435F28.3000301@novell.com> <20090625115403.GA7079@redhat.com> <4A4368A4.8030401@novell.com> <20090625123757.GA7121@redhat.com> <4A437564.6060308@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A437564.6060308@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 09:02:28AM -0400, Gregory Haskins wrote:
> > Here's what I have in mind:
> > kvm does
> > 	lock
> > 	dev = find
> > 	unlock
> >
> > 	<---------- at this point group device is removed
> >
> > 	write access to device that has been removed
> >
> >
> >   
> 
> Hmm...you are right.  This looks like it was introduced with that recent
> locking patch you cited.  Well, I can still fix it now easily by putting
> an rcu-read-lock around the access.  Longer term we should move to
> srcu.  Thoughts?
> 
> -Greg
> 


Some callbacks take kvm mutex lock. So it seems rcu won't work,
we need srcu.

-- 
MST

