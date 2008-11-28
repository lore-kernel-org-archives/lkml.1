Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYK1Q6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYK1Q6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYK1Q6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:58:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59020 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752132AbYK1Q6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:58:24 -0500
Date: Fri, 28 Nov 2008 16:58:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, dlaor@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, corbet@lwn.net,
       ieidus@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver.
Message-ID: <20081128165806.172d1026@lxorguk.ukuu.org.uk>
In-Reply-To: <1226888432-3662-4-git-send-email-ieidus@redhat.com>
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com>
	<1226888432-3662-2-git-send-email-ieidus@redhat.com>
	<1226888432-3662-3-git-send-email-ieidus@redhat.com>
	<1226888432-3662-4-git-send-email-ieidus@redhat.com>
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

> +	r = !memcmp(old_digest, sha1_item->sha1val, SHA1_DIGEST_SIZE);
> +	mutex_unlock(&sha1_lock);
> +	if (r) {
> +		char *old_addr, *new_addr;
> +		old_addr = kmap_atomic(oldpage, KM_USER0);
> +		new_addr = kmap_atomic(newpage, KM_USER1);
> +		r = !memcmp(old_addr+PAGEHASH_LEN, new_addr+PAGEHASH_LEN,
> +			    PAGE_SIZE-PAGEHASH_LEN);

NAK - this isn't guaranteed to be robust so you could end up merging
different pages one provided by a malicious attacker.
