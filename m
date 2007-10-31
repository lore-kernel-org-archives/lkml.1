Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXJaMAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXJaMAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXJaMAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:00:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22507 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbXJaMAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:00:36 -0400
Date: Wed, 31 Oct 2007 12:57:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Drake <dsd@gentoo.org>, linux list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071031115754.GK5059@kernel.dk>
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu> <47278439.4030801@gentoo.org> <20071031114958.210bd7cc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031114958.210bd7cc@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007, Alan Cox wrote:
> On Tue, 30 Oct 2007 19:21:29 +0000
> Daniel Drake <dsd@gentoo.org> wrote:
> 
> > Alan Cox wrote:
> > > I would guess Brasero is issuing a command with the length of data
> > > wrongly set. In the old code that might well just produce errors of the
> > > "Umm wtf is this data left over for ?", with the new code the drive is
> > > likely to change state as it knows the transfer size and that will
> > > *correctly* cause an HSM error and what follows.
> > > 
> > > Now the question is who gets the length wrong - Brasero or the ata
> > > translation code in libata
> > 
> > Brasero does exactly the same as my test app which I attached to my last 
> > mail. Is my test app wrong?
> 
> Would need to double check the SCSI specificatons to be sure but I think
> you are asking for less data than the drive wishes to provide. You
> aren't allowed to do that with ATA.

ide-cd handles this by throwing the excess away, which I think is the
sane way to do this.

-- 
Jens Axboe

