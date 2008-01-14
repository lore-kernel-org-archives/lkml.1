Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYANGYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYANGYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYANGYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:24:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57678 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583AbYANGYl (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:24:41 -0500
Date: Mon, 14 Jan 2008 17:24:32 +1100
From: David Chinner <dgc@sgi.com>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is deleting (or reading) files not counted as IO-Wait in top?
Message-ID: <20080114062432.GN155259@sgi.com>
References: <20080102193503.GA31414@citd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102193503.GA31414@citd.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 08:35:03PM +0100, Matthias Schniedermeyer wrote:
> Hi
> 
> 
> Currently i'm deleting about 500.000 files on a XFS-filesystem which 
> takes a few minutes, as i had a top open i saw that 'wa' is shown as 
> 0.0% (Nothing else running currently) and everything except 'id' is near 
> the bottom too. Kernel is 2.6.23.11.

Simply because the only I/O that XFS does during a delete is
to the log and the log does async I/O and hence the process
never blocks in I/O.

Instead, it blocks in a far more complex space reservation that
may or may not be related to I/O wait....

> So, as 'rm -rf' is essentially a IO (or seek, to be more correct)-bound 
> task, shouldn't that count as "Waiting for IO"?

rm -rf is not seek bound on XFS - it's generally determined by
the sequential write speed of the block device or how fast your
CPU is....

> The man-page of top says:
> 'Amount of time the CPU has been waiting for I/O to complete.'

Async I/O means that typically your CPU does not get held up
waiting for I/O to complete....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
