Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZHZC7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZHZC7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZHZC7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:59:04 -0400
Received: from thunk.org ([69.25.196.29]:56502 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZHZC7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:59:02 -0400
Date: Tue, 25 Aug 2009 22:58:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090826025849.GF32712@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A948C94.7040103@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 09:15:00PM -0400, Ric Wheeler wrote:
>
> I agree with the whole write up outside of the above - degraded RAID  
> does meet this requirement unless you have a second (or third, counting  
> the split write) failure during the rebuild.

The argument is that if the degraded RAID array is running in this
state for a long time, and the power fails while the software RAID is
in the middle of writing out a stripe, such that the stripe isn't
completely written out, we could lose all of the data in that stripe.

In other words, a power failure in the middle of writing out a stripe
in a degraded RAID array counts as a second failure.

To me, this isn't a particularly interesting or newsworthy point,
since a competent system administrator who cares about his data and/or
his hardware will (a) have a UPS, and (b) be running with a hot spare
and/or will imediately replace a failed drive in a RAID array.

       	    	       	       	 	      - Ted
