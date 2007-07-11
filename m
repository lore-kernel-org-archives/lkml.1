Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbXGKTTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbXGKTTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbXGKTTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbXGKTTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=C7PXo4AG+JvtS7Gx5jZeGuvXFFKeK4RPSKLxQWOzvOZv86vSUFvd3WpbZKoyFXJiS
	lA0+tQ/uoqQzyMm0DGjjw==
Message-ID: <46952D0A.1090304@google.com>
Date: Wed, 11 Jul 2007 12:18:34 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com> <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com> <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Christoph -- I have a question about one part of the patches. In
throttle_vm_writeout() you added a clause that checks for __GFP_FS |
__GFP_IO and if they're not both set it calls blk_congestion_wait()
immediately and then returns, no change for looping. Two questions:

1. This seems like an unrelated bug fix. Should you submit it as a
standalone patch?

2. You put this gfp check before the check for get_dirty_limits. It's
possible that this will block even though without your change it would
have returned straight away. Would it better, instead of adding the
if-clause at the top of the function, to embed the gfp check at the end
of the for-loop after calling blk_congestion_wait?

	-- Ethan

