Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYKMOln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYKMOln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKMOlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:41:35 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:58487 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYKMOle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:41:34 -0500
Date: Thu, 13 Nov 2008 08:40:32 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <200811131951.07686.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811130830210.19293@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811130831.11499.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0811121630390.2379@quilx.com> <200811131951.07686.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Rusty Russell wrote:

> > The cpu alloc patchset gets rid of about half the hooks in the page
> > allocator and slab allocator.
>
> Sure, but we could convert those today to alloc_percpu etc.

The percpu_ptr macros etc are not upercase suggesting that it is a
function but the functions do weird things like passing through the
type. This is confusing.

alloc_percpu() does not allow specifying a GFP mask therefore does not
support zeroing and is not extendable for the future. It does not allow
specifying an alignment therefore tight packing is not possible.

Plus the name alloc_percpu() suggests that it is a function but its a
macro doing things with typing.

CPU_PTR and THIS_CPU can be applied both to percpu pointers and
percpu variables. The new API unifies the handling which is required in
order for the new cpu_ops to work both on statically and dynamically
allocated percpu data.

