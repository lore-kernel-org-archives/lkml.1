Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXJSG6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXJSG6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXJSG6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:58:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:37060 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXJSG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AFKekiRc9v6YmCytMsoXXP14m3I4fpU3r3J79MaHVAChhYQ0wuviGZKHcmNWEEuUSGOM+dIQC/dJWEPTelhjhviYQbDrcWpVJaTnjqpkHO5USLRXDfylZGKXyV2yN47QL3DrArmj7j8zGFF8ztJAsZR09OLvI5fuwTxzUe3hiaM=
Message-ID: <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>
Date: Fri, 19 Oct 2007 14:58:19 +0800
From: "peer chen" <peerchen@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       "Kuan Luo" <kluo@nvidia.com>
In-Reply-To: <47181CE1.4000802@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>
	 <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>
	 <47181CE1.4000802@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,I agree to use AHCI driver for our AHCI controllers no matter their
class codes are IDE/RAID/AHCI. But for those new or upcoming AHCI
controller which DIDs are not included in ahci.c and also IDE/RAID
mode being set in BIOS, no driver will be loaded currently, so I hope
the first patch http://lkml.org/lkml/2007/10/8/93 can be appied for
this case. Any comments?

2007/10/19, Jeff Garzik <jeff@garzik.org>:
> peer chen wrote:
> > I hope one of the following patches can be merged to 2.6.24.
> > ==========================
> > http://lkml.org/lkml/2007/10/8/93
> > http://lkml.org/lkml/2007/9/25/20
>
> Unfortunately I do not feel like this is the right course of action.
>
> Experience from Intel platforms tells us that our users get very unhappy
> when their silicon supports AHCI mode, but they are forced into using a
> less-performant mode.  A popular example is an <unnamed> OEM whose BIOS
> had no method whatsoever for enabling AHCI -- didn't even program the
> PCI BAR -- even though tests showed the AHCI mode worked just fine when
> manually programmed.
>
> AHCI is more likely to provide a /stable/ Serial ATA experience, because
> the silicon deals primarily with sending and receiving FIS's, and not
> much else.  In constrast, experience has shown the legacy IDE interface
> to be a less reliable method of SATA support.  And certainly AHCI is
> much, much faster with less per-command overhead.
>
> Given that AHCI is both faster and more stable, I feel it is the best
> policy to enable AHCI when the hardware supports it, regardless of PCI
> class code (IDE, SATA, or RAID).
>
>
> > Yes, I agree to set the 'swncq' as default for 2.6.24, after all, for
> > our server customers, stability is far more important than the new
> > feature no matter the problem is caused by drive or controller.
>
> Agreed.  Done!
>
>        Jeff
>
>
>
>
>
