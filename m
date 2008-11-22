Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYKVLds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYKVLds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYKVLdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:33:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:20975 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbYKVLdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=MpKYgvTTqcItIu3qrxk1AXFW+OZkjzccSth69XOrjTH4wwfcxb7wLhDHl1gP7UDJYK
         QaC43QH1MU7DG0LbEqJ03sFy4nIBujErWkrvAfmqMHOR6qdkk1o/gTVZmg+n1zi54sQP
         RTq9Uv0AvaxJlUnc6Ueq3ZnSCKIPQseog9w9k=
Date: Sat, 22 Nov 2008 12:33:42 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Remy LABENE <remy.labene@free.fr>
Subject: Re: [PATCH] amd74xx: workaround unreliable AltStatus register for
	nVidia controllers
Message-ID: <20081122113342.GA8593@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	Remy LABENE <remy.labene@free.fr>
References: <200811212238.51161.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811212238.51161.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 10:38:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> It seems that on some nVidia controllers using AltStatus register
> can be unreliable so default to Status register if the PCI device
> is in Compatibility Mode.  In order to achieve this:
> 
> * Add ide_pci_is_in_compatibility_mode() inline helper to <linux/ide.h>.
> 
> * Add IDE_HFLAG_BROKEN_ALTSTATUS host flag and set it in amd74xx host
>   driver for nVidia controllers in Compatibility Mode.
> 
> * Teach actual_try_to_identify() and drive_is_ready() about the new flag.
> 
> This fixes the regression caused by removal of CONFIG_IDEPCI_SHARE_IRQ
> config option in 2.6.25 and using AltStatus register unconditionally when
> available (kernel.org bug #11659).  [ Moreover for CONFIG_IDEPCI_SHARE_IRQ=y
> (which is what most distributions/people use) it never worked correctly. ]

Looks good.

Acked-by: Borislav Petkov <petkovbb@gmail.com>

> 
> Thanks to Remy LABENE for help with debugging the problem.
> 
> More info at:
> http://bugzilla.kernel.org/show_bug.cgi?id=11659

Bugzilla entry can be closed now.

[.. ]

-- 
Regards/Gruss,
    Boris.
