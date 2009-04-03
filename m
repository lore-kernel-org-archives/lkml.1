Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZDCGbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZDCGbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZDCGbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:31:07 -0400
Received: from thunk.org ([69.25.196.29]:60760 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZDCGbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:31:06 -0400
Date: Fri, 3 Apr 2009 02:30:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: David Rees <drees76@gmail.com>, Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
Message-ID: <20090403063059.GO9870@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Trenton D. Adams" <trenton.d.adams@gmail.com>,
	David Rees <drees76@gmail.com>,
	Christian Kujau <lists@nerdbynature.de>,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com> <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com> <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com> <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com> <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com> <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com> <20090403050246.GM9870@mit.edu> <9b1675090904022215u612a3c06g98c3dcf3e74571a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1675090904022215u612a3c06g98c3dcf3e74571a2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:15:29PM -0600, Trenton D. Adams wrote:
> 
> tdamac ~ # mount -t ext3 -o data=writeback,remount,rw /dev/s/sys /
> mount: / not mounted already, or bad option
> 
> Does it have to be done on initial mount?

Yes, which means you have to use the rootflags boot command-line
option.

It's a pain that we can't switch data= modes on the fly.  I believe
the problematic transiations are between data=journal and
data=!journal.  Transitions between data=ordered and data=writeback
should be easy to add.

						- Ted



