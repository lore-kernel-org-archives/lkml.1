Return-Path: <linux-kernel-owner+w=401wt.eu-S1764857AbYEOVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857AbYEOVsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYEOVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:47:57 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37957 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbYEOVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:47:56 -0400
Date: Thu, 15 May 2008 17:47:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080515214721.GP18825@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Peterson <cpeterso@cpeterso.com>,
	Jeff Garzik <jeff@garzik.org>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Rick Jones <rick.jones2@hp.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <a24804730805151301s3c6644d0hc2c78b8008fe035d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24804730805151301s3c6644d0hc2c78b8008fe035d@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 01:01:36PM -0700, Chris Peterson wrote:
> Please correct me if I'm wrong, but this thread's conclusions seem to be:
> 
> * network interrupts are an inappropriate source of entropy (see my patch)
> * headless servers need entropy, but should seek a better solution,
> such as EGD, hardware RNG, or other kernel entropy sources (but that
> is a separate task)
> * TPM RNG is a separate task and, if implemented, should be in
> drivers/char/hw_random/

The TPM RNG task is probably best done in a user space process, which
might also do other things like pulling environmental noise from the
sound card's microphone, etc.

The problem is finding someone with the skills, time, and energy to
create the appropriate user space daemon.  All of the kernel
interfaces already exist; it's just matter of implementing the user
space support.

						- Ted
