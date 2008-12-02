Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYLBWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYLBWLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYLBWLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:11:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51854 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752566AbYLBWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:11:23 -0500
Date: Tue, 2 Dec 2008 22:10:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Wright <chrisw@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       avi@redhat.com, dlaor@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       cl@linux-foundation.org, corbet@lwn.net
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver.
Message-ID: <20081202221029.513e8774@lxorguk.ukuu.org.uk>
In-Reply-To: <20081202212411.GG17607@acer.localdomain>
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com>
	<1226888432-3662-2-git-send-email-ieidus@redhat.com>
	<1226888432-3662-3-git-send-email-ieidus@redhat.com>
	<1226888432-3662-4-git-send-email-ieidus@redhat.com>
	<20081128165806.172d1026@lxorguk.ukuu.org.uk>
	<20081202180724.GC17607@acer.localdomain>
	<20081202181333.38c7b421@lxorguk.ukuu.org.uk>
	<20081202212411.GG17607@acer.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 13:24:11 -0800
Chris Wright <chrisw@redhat.com> wrote:

> * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > On Tue, 2 Dec 2008 10:07:24 -0800
> > Chris Wright <chrisw@redhat.com> wrote:
> > > * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > > > +	r = !memcmp(old_digest, sha1_item->sha1val, SHA1_DIGEST_SIZE);
> > > > > +	mutex_unlock(&sha1_lock);
> > > > > +	if (r) {
> > > > > +		char *old_addr, *new_addr;
> > > > > +		old_addr = kmap_atomic(oldpage, KM_USER0);
> > > > > +		new_addr = kmap_atomic(newpage, KM_USER1);
> > > > > +		r = !memcmp(old_addr+PAGEHASH_LEN, new_addr+PAGEHASH_LEN,
> > > > > +			    PAGE_SIZE-PAGEHASH_LEN);
> > > > 
> > > > NAK - this isn't guaranteed to be robust so you could end up merging
> > > > different pages one provided by a malicious attacker.
> > > 
> > > I presume you're referring to the digest comparison.  While there's
> > > theoretical concern of hash collision, it's mitigated by hmac(sha1)
> > > so the attacker can't brute force for known collisions.
> > 
> > Using current known techniques. A random collision is just as bad news.
> 
> And, just to clarify, your concern would extend to any digest based
> comparison?  Or are you specifically concerned about sha1?

Taken off list 
