Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbXHAVZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbXHAVZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXHAVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:25:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51727 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXHAVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:25:33 -0400
Date: Thu, 2 Aug 2007 03:07:58 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Chris Rankin <rankincj@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.22 - Atomic counter underflow in NFS
In-Reply-To: <699754.45152.qm@web52901.mail.re2.yahoo.com>
Message-ID: <alpine.LFD.0.999.0708020302570.8258@enigma.security.iitk.ac.in>
References: <699754.45152.qm@web52901.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Aug 2007, Chris Rankin wrote:

> --- Satyam Sharma <satyam@infradead.org> wrote:
> > I expect this is easy to reproduce at will (when shutting down nfs
> > services, probably), right?
> 
> I'm not sure about the "at will" part because this is the first time I've seen it since 2.6.22 was
> released. However, I was upgrading my Fedora 7 nfs-utils package at the time so it probably did
> happen when the NFS service was being shut down.

Hmm, the backtrace suggests it should be reproducible fairly frequently.

> > Please try the latest mainline -git kernel (say 2.6.23-rc1-git10 from
> > kernel.org) and let us know if this still occurs? There were some fixes
> > regarding sysfs symlink refcounting that went in recently, and this looks
> > like one of those cases to me.
> 
> Do you have the actual patches instead?

I was thinking maybe this one: http://lkml.org/lkml/diff/2007/7/18/48/1

The kref_put() there happens on the sysfs_remove_link() path, and the
patch above fixed an extra put() during create_link(), which lead to
the final put() during remove_link() being what causes this underflow.
However, a lot changed in sysfs in the past few months, and I'm not
really sure that patch would apply cleanly. Hence, if you can try with
the latest -git ...


Thanks,
Satyam
