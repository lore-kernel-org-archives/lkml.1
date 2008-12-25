Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbYLYN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbYLYN1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYLYN1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:27:09 -0500
Received: from ozlabs.org ([203.10.76.45]:46243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYLYN1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:27:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] percpu_counter: use local_t and atomic_long_t if possible
Date: Thu, 25 Dec 2008 23:56:58 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com> <49424637.3010107@cosmosbay.com> <1230032601.9487.247.camel@twins>
In-Reply-To: <1230032601.9487.247.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812252356.59595.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2008 22:13:21 Peter Zijlstra wrote:
> One think that sprung to mind,..
> 
> IFF we're going to implement percpu_counter with local_t and make
> local_t this funny tri-counter thing which has its own error, you need
> to fix up bdi_stat_error() - it expects to be an upper bound for the
> counter error, getting that wrong _will_ cause deadlocks.

It's OK: local_add_return() can't have error; that's why the trival
implementation disables interrupts around it.

Hope that helps,
Rusty.
