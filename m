Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYKZEqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYKZEqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYKZEqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:46:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:37921 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYKZEqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:46:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Al38xGgdyko3AAWE/Hz2sGYRdp8axVfjDwjlPDr13fVGHalxVMunjYc7oK9WUqMqhX
         iCYLX94HXhH0/AykXwD53qDUsELi5zGQVlola/z6E5fUmJlz9J46wa2SR+KwNcEzLTjh
         3FLdRD2SJnRJPFkzhcuuKN1s3mOM63/Ov+BGI=
Date: Wed, 26 Nov 2008 07:50:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add per-cpu indexing to /proc/timer_list
Message-ID: <20081126045004.GA3278@x200.localdomain>
References: <20081125224439.GA24042@tsunami.ccur.com> <20081125231445.GA24326@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125231445.GA24326@tsunami.ccur.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 06:14:45PM -0500, Joe Korty wrote:
> Per-cpu indexing of /proc/timer_list.
> 
> /proc/timer_list, potentially a very large file, is in
> danger of overflowing its seq_file buffer.  So 'split up'
> the buffering on cpu ID boundaries.  This should make this
> file more likely to be useful on largish SMP systems.

What do you mean?

You can't overflow seq_file buffer unless kmalloc() will fail large
allocation. And changing internals doesn't change amount of stuff
to be shown, which is the only thing which can lead to large buffer
need.

> The model followed is that in /proc/interrupts, which
> splits up its buffering on (most) irq boundaries.
