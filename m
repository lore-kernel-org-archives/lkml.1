Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYLBSI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYLBSI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYLBSIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:08:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44104 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYLBSIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:08:16 -0500
Date: Tue, 2 Dec 2008 10:07:24 -0800
From: Chris Wright <chrisw@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com,
       dlaor@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       cl@linux-foundation.org, corbet@lwn.net
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver.
Message-ID: <20081202180724.GC17607@acer.localdomain>
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com> <1226888432-3662-2-git-send-email-ieidus@redhat.com> <1226888432-3662-3-git-send-email-ieidus@redhat.com> <1226888432-3662-4-git-send-email-ieidus@redhat.com> <20081128165806.172d1026@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128165806.172d1026@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > +	r = !memcmp(old_digest, sha1_item->sha1val, SHA1_DIGEST_SIZE);
> > +	mutex_unlock(&sha1_lock);
> > +	if (r) {
> > +		char *old_addr, *new_addr;
> > +		old_addr = kmap_atomic(oldpage, KM_USER0);
> > +		new_addr = kmap_atomic(newpage, KM_USER1);
> > +		r = !memcmp(old_addr+PAGEHASH_LEN, new_addr+PAGEHASH_LEN,
> > +			    PAGE_SIZE-PAGEHASH_LEN);
> 
> NAK - this isn't guaranteed to be robust so you could end up merging
> different pages one provided by a malicious attacker.

I presume you're referring to the digest comparison.  While there's
theoretical concern of hash collision, it's mitigated by hmac(sha1)
so the attacker can't brute force for known collisions.

thanks,
-chris
