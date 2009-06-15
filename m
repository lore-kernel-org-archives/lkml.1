Return-Path: <linux-kernel-owner+w=401wt.eu-S935808AbZFOV56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935808AbZFOV56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZFOV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:57:51 -0400
Received: from louise.pinerecords.com ([213.168.176.16]:54461 "EHLO
	louise.pinerecords.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZFOV5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:57:51 -0400
Date: Mon, 15 Jun 2009 23:57:46 +0200
From: =?utf-8?B?VG9tw6HFoSBTesOpcGU=?= <szepe@pinerecords.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [2.6.29.x+ FIX] CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
Message-ID: <20090615215746.GC10235@louise.pinerecords.com>
References: <20090611024630.GA24852@louise.pinerecords.com> <20090615144511.aae5e50d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090615144511.aae5e50d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Fix: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.
> > Patch against 2.6.29.*, 2.6.30, current.
> > 
> > inlined please find a trivial fix that makes it possible to run
> > complete systems out of an initramfs on current kernels again
> > (this last worked on 2.6.27.*).
> 
> Please describe the problem more completely.  Why is it not possible? 
> What goes wrong?  Your initramfs kernel has CONFIG_BLOCK=n?

Precisely.  Without this patch and with CONFIG_BLOCK unset, CONFIG_FILE_LOCKING
is forced to "n", which makes it impossible to run things as elementary as "mount",
they'll all fail with "flock(): not implemented" and similar.

I believe this is an apparent inconsistency between real code dependencies
(locks.o does not need the block layer compiled to successfully link) and
config symbol dependencies.

> Also, please do include a Signed-off-by: with each patch - see
> Documentation/SubmittingPatches for a description.

Ah, sorry, I haven't submitted a patch in years.

-- 
Tomáš Szépe <szepe@pinerecords.com>
