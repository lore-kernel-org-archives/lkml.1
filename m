Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZHLSdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZHLSdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZHLSdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:33:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:35993 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZHLSdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:33:36 -0400
Subject: Re: [PATCH] swap: send callback when swap slot is freed
From: Peter Zijlstra <peterz@infradead.org>
To: ngupta@vflare.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <200908122007.43522.ngupta@vflare.org>
References: <200908122007.43522.ngupta@vflare.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Aug 2009 20:33:12 +0200
Message-Id: <1250101992.10001.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 20:07 +0530, Nitin Gupta wrote:
> Currently, we have "swap discard" mechanism which sends a discard bio request
> when we find a free cluster during scan_swap_map(). This callback can come a
> long time after swap slots are actually freed.
> 
> This delay in callback is a great problem when (compressed) RAM [1] is used
> as a swap device. So, this change adds a callback which is called as
> soon as a swap slot becomes free. For above mentioned case of swapping
> over compressed RAM device, this is very useful since we can immediately
> free memory allocated for this swap page.
> 
> This callback does not replace swap discard support. It is called with
> swap_lock held, so it is meant to trigger action that finishes quickly.
> However, swap discard is an I/O request and can be used for taking longer
> actions.

I'd suggest using a notifier list for this. The interface just begs to
go belly up once there's multiple consumers.

Also, EXPORT_SYMBOL_GPL please ;-)
