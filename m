Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbYKMJVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbYKMJVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYKMJVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:21:19 -0500
Received: from ozlabs.org ([203.10.76.45]:40072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYKMJVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:21:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Thu, 13 Nov 2008 19:51:06 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811130831.11499.rusty@rustcorp.com.au> <Pine.LNX.4.64.0811121630390.2379@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811121630390.2379@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131951.07686.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2008 09:20:46 Christoph Lameter wrote:
> The old api was based on an attempt to introduce a cpu mask. That mask was
> never used. See percpu_alloc_mask. The handling is not consistent with the
> nature of the percpu sections for other percpu data because allocation is
> only done for online processors. So we have semantic differences. The API
> is inconsistent and underwent rot.

Yes, but I was talking about the original percpu API: 
alloc_percpu/free_percpu/per_cpu_ptr.  That's the only bit that counts, as 
it's the only bit that's used.  Yes, the percpu_alloc should die.

Just convert *that API* to your new implementation, and drop all the 
conversion patches.  I said this back in June.

> The cpu alloc patchset gets rid of about half the hooks in the page
> allocator and slab allocator.

Sure, but we could convert those today to alloc_percpu etc.
Rusty.
