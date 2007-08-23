Return-Path: <linux-kernel-owner+w=401wt.eu-S1765110AbXHWRiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765110AbXHWRiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbXHWRiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:38:02 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:10380 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbXHWRiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=hkQiM9R1k2ownP14c39qp1TkjcTfv6cSIPV3RibYemVFwUrf8GXsfKuOcnxw+CrnWm8ijMYK1MX1OUH4f15SbbNeQ3/umN749qk2mczoOniUIsoU2quTjNFKP5iGZmABv3MOD7REZZnwp9svMeQDnQmoTw7+FR0XTPGMe9Ac8Os=
Date: Thu, 23 Aug 2007 21:37:55 +0400
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - irda goes belly up
Message-ID: <20070823173754.GA1818@martell.zuzino.mipt.ru>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23568.1187876026@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 09:33:46AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 22 Aug 2007 02:06:48 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> OK, so I don't actually *use* the irDA on my laptop for much, but I figure if
> I have the hardware, I should at least make sure the driver comes up.
> 
> 23-rc3-mm1 causes massive spewage, apparently at least partially as a fall-out
> of the sysctl rework.  Not sure if those caused the 'unknown symbol' issues or
> not.  The 'cannot allocate memory' is somewhat odd too, I can't believe it was
> *really* out of memory while still in /etc/rc5.d when I have 2G of ram...

Eric is a bit sadistic with sysctls. If sysctl_check_table() fails
irda_sysctl_register() will think there is no memory.

As for unknown symbols, hell knows. Same as with multiple syscts errors.
What have you modprobed exactly and what is $(grep IRDA .config) ?

> kernel: [  247.804000] NET: Registered protocol family 23
> kernel: [  247.804000] sysctl table check failed: /net/irda .3.412 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/discovery .3.412.1 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/devname .3.412.2 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/debug .3.412.3 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/fast_poll_increase .3.412.4 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/discovery_slots .3.412.5 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/discovery_timeout .3.412.6 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/slot_timeout .3.412.7 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/max_baud_rate .3.412.8 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/min_tx_turn_time .3.412.9 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/max_tx_data_size .3.412.10 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/max_tx_window .3.412.11 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/max_noreply_time .3.412.12 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/warn_noreply_time .3.412.13 Unknown sysctl binary path
> kernel: [  247.804000] sysctl table check failed: /net/irda/lap_keepalive_time .3.412.14 Unknown sysctl binary path
> kernel: [  247.816000] NET: Unregistered protocol family 23
> kernel: [  247.826000] ircomm: Unknown symbol hashbin_insert
	...
