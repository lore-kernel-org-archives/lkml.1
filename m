Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYK2XUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYK2XUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 18:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYK2XUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 18:20:30 -0500
Received: from ozlabs.org ([203.10.76.45]:33258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYK2XU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 18:20:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18737.52782.650416.444270@cargo.ozlabs.ibm.com>
Date: Sun, 30 Nov 2008 10:20:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: powerpc: hv{cs,
	si}_close() both unsigned hp->count and hvcsd->open_count
	cannot be negative
In-Reply-To: <4931201D.7060701@gmail.com>
References: <4931201D.7060701@gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin writes:

> unsigned hp->count and hvcsd->open_count cannot be negative
...
> -	if (--hvcsd->open_count == 0) {
> +	if (hvcsd->open_count == 1) {
> +		hvcsd->open_count--;

Why are we no longer decrementing hvcsd->open_count in the cases where
it is greater than 1?

> -	if (--hp->count == 0) {
> +	if (hp->count == 1) {
> +		hp->count--;

Ditto with hp->count here?

Also, I don't see why those changes have anything to do with "unsigned
things cannot be negative".  As long as those counts are never zero on
entry to those code sections, the existing code is fine, and I believe
that assertion can be maintained.  If you believe the code needs to
defend against the possibility of a zero count on entry, that should
have been explicitly stated in the patch description.

Paul.
