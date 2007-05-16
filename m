Return-Path: <linux-kernel-owner+w=401wt.eu-S1761182AbXEPLiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182AbXEPLiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXEPLij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:38:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:2914 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbXEPLii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eWdz86lkXohukwLQeVZFj6Xh18N56Faed78kyl0tO0qoodxij59tGso1Nn+jwf5cOsduYC/Vbt31HOaQXn1WFkx9tgHSvoGoiQoPpbEg1Qi+fNGmCdUYrLvrle3dTcvWLzhQ3ITf0/ggz0bsx0LRmllz5aTFWGygFftjwGf7CyY=
Message-ID: <464AED2C.8040201@gmail.com>
Date: Wed, 16 May 2007 13:38:20 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Francesco Pretto <ceztko@gmail.com>
CC: Rob Landley <rob@landley.net>, Dave Jones <davej@redhat.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>	 <46489D3B.8050805@gmail.com> <20070515210804.GG25902@redhat.com>	 <200705160129.16048.rob@landley.net> <e5ab0f710705160215p6b11bffeh53796b1b2223fd6d@mail.gmail.com>
In-Reply-To: <e5ab0f710705160215p6b11bffeh53796b1b2223fd6d@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francesco Pretto wrote:
> For what i understood, there were a misunderstanding caused by the
> wrong assumption that shutdown(8) implementations were issuing
> STANDBYNOW on all hard disk devices on the system (indistinctly from
> the interface, old-ide/libata/scsi). The fact is that sysvinit and
> others actually do something with the old interface /proc/ide, trying
> to spindown the hard disks. This worked only on systems using the old
> ide/ata drivers because kernel prior to 2.6.22rc1 didn't even have the
> necessary feature to spindown hard disks using the libata or the scsi
> interface.
> 
> Hopefully, with the patch in discussion, there will be an happy ending
> with:
> 
> - sysvinit and derived implementations:
> if ( old ide/ata drivers are used )
>  {continue to do the old userland spindown mechanism with /proc/ide; }
> // else
> //  { do nothing; }
> reboot();
> 
> - everyone else:
> // continue to do nothing :-)
> reboot();

Yeap, exactly.  The patch has been accepted, I'll update the web page soon.

> If exists some, at this point, exotic shutdown(8) implementation that
> is trying to issue STANDBYBOW on libata/scsi devices, it will get a
> fat warning. The warning could also state that the only supported way
> is to leave complete responsibility of spinning down the hard disks to
> kernel, so eventually it could be cleaned of checks and compatibility
> options.

It does exist.  It's my primary testing machine - a debian installation
which doesn't get updated too often.  The only problem is that I'm half
globe away from that machine until the end of the month.

So, anyways, things are looking much brighter now.

-- 
tejun
