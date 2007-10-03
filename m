Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbXJCT4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbXJCT4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXJCTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:55:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39827 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbXJCTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:55:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <roland@digitalvampire.org>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: MSI: Use correct data offset for 32-bit MSI in read_msi_msg()
References: <87abr0oyj4.fsf@shaolin.home.digitalvampire.org>
	<m1ir5ocaxr.fsf@ebiederm.dsl.xmission.com>
	<874ph8ovtm.fsf@shaolin.home.digitalvampire.org>
Date: Wed, 03 Oct 2007 13:55:10 -0600
In-Reply-To: <874ph8ovtm.fsf@shaolin.home.digitalvampire.org> (Roland Dreier's
	message of "Wed, 03 Oct 2007 12:13:41 -0700")
Message-ID: <m17im4c6sh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <roland@digitalvampire.org> writes:

>  > > While reading the MSI code trying to find a reason why MSI wouldn't
>  > > work for devices that have a 32-bit MSI address capability, I noticed
>  > > that read_msi_msg() seems to read the message data from the wrong
>  > > offset in this case.
>  > 
>  > Doh!  Sorry about that.
>
> Doesn't matter, it wasn't the bug hitting me anyway :) the IRQ never
> got affinity changed so read_msi_msg() never even got called.
>
> I'm starting to think that Intel 945GM graphics just has a busted MSI
> implementation, although there may be a bug hiding in the Linux code
> that I'm not seeing.

Well it is a bug worth fixing.  Who knows it may have something
to do with the disable_irq problems the forcedeth driver was seeing.

Right now MSI is still sufficiently new that everyone is still getting
the bugs out of their implementations.

Eric
