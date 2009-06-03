Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZFCIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZFCIHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZFCIHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:07:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:44228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbZFCIHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:07:34 -0400
Date: Wed, 3 Jun 2009 10:07:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matt LaPlante <kernel1@cyberdogtech.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless
 tree
In-Reply-To: <20090603152247.b52f552e.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0906031006270.7457@wotan.suse.de>
References: <20090603152247.b52f552e.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in 
> Documentation/rfkill.txt between commit 
> c6d660ce29295d344fcdc3654274b4a0aad1a9c8 ("rfkill: rewrite") from the 
> wireless tree and commit 9976d9daf91d146724ad9c336f74c60d2195c386 
> ("trivial: Miscellaneous documentation typo fixes") from the trivial 
> tree.
> I just used the version from the wireless tree since it has been
> basically rewritten there (except I applied the "transmiter" to
> "transmitter" fix - see below).  Maybe the part of the trivial tree patch
> that affects this file should be dropped.

Hi,

thanks for letting me know. I have dropped the Documentation/rfkill.txt 
hunk completely. 

Wireless guys, will you please apply the transmiter -> transmitter fix to 
your tree?

Thanks.

> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@@ -111,20 -545,31 +111,20 @@@ The following sysfs entries exist for e
>   	type: Name of the key type ("wlan", "bluetooth", etc).
>   	state: Current state of the transmitter
>   		0: RFKILL_STATE_SOFT_BLOCKED
>  -			transmitter is forced off, but one can override it
>  -			by a write to the state attribute;
>  +			transmitter is turned off by software
>   		1: RFKILL_STATE_UNBLOCKED
> - 			transmiter is (potentially) active
>  -			transmitter is NOT forced off, and may operate if
>  -			all other conditions for such operation are met
>  -			(such as interface is up and configured, etc);
> ++			transmitter is (potentially) active
>   		2: RFKILL_STATE_HARD_BLOCKED
>   			transmitter is forced off by something outside of
>  -			the driver's control.  One cannot set a device to
>  -			this state through writes to the state attribute;
>  -	claim: 1: Userspace handles events, 0: Kernel handles events
>  -
>  -Both the "state" and "claim" entries are also writable. For the "state" entry
>  -this means that when 1 or 0 is written, the device rfkill state (if not yet in
>  -the requested state), will be will be toggled accordingly.
>  -
>  -For the "claim" entry writing 1 to it means that the kernel no longer handles
>  -key events even though RFKILL_INPUT input was enabled. When "claim" has been
>  -set to 0, userspace should make sure that it listens for the input events or
>  -check the sysfs "state" entry regularly to correctly perform the required tasks
>  -when the rkfill key is pressed.
>  -
>  -A note about input devices and EV_SW events:
>  -
>  -In order to know the current state of an input device switch (like
>  -SW_RFKILL_ALL), you will need to use an IOCTL.  That information is not
>  -available through sysfs in a generic way at this time, and it is not available
>  -through the rfkill class AT ALL.
>  +			the driver's control.
>  +	claim: 0: Kernel handles events (currently always reads that value)
>  +
>  +rfkill devices also issue uevents (with an action of "change"), with the
>  +following environment variables set:
>  +
>  +RFKILL_NAME
>  +RFKILL_STATE
>  +RFKILL_TYPE
>  +
>  +The contents of these variables corresponds to the "name", "state" and
>  +"type" sysfs files explained above.
> 

-- 
Jiri Kosina
SUSE Labs
