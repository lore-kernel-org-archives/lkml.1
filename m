Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXDPVrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXDPVrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXDPVrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:47:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXDPVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:47:13 -0400
Message-ID: <4623EE59.7090005@redhat.com>
Date: Mon, 16 Apr 2007 17:44:57 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       alsa-devel@alsa-project.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/2] 2.6.21-rc7: known regressions
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003714.GL3691@stusta.de>
In-Reply-To: <20070416003714.GL3691@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> Subject    : snd_intel8x0: divide error: 0000
> References : http://lkml.org/lkml/2007/3/5/252
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Status     : unknown
> 

Oops is in sound/pci/intel8x0.c::snd_intel8x0_update(), part of
the interrupt handler:

Line 751:

        ichdev->position += step * ichdev->fragsize1;
        if (! chip->in_measurement)
                ichdev->position %= ichdev->size;

ichdev->size is 0. Interrupt happened upon request_irq().

Does chip->in_measurement need to be reset because this is a
crashdump kernel?
