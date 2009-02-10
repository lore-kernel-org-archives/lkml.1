Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZBJN6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZBJN6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZBJN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:58:21 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51813 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZBJN6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:58:19 -0500
Date: Tue, 10 Feb 2009 04:36:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alex Chiang <achiang@hp.com>, tony.luck@intel.com, stable@kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ia64: prevent irq migration race in
	__cpu_disable path
Message-ID: <20090210123645.GA7542@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090209181338.GD19064@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209181338.GD19064@ldl.fc.hp.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 11:13:38AM -0700, Alex Chiang wrote:
> This is v2 of my attempt to prevent an oops while offlining CPUs.
> 
> The change is that the patch becomes a full revert of Paul's
> original patch, along with a long changelog that explains the
> situation as best as I can determine. It's not 100% satisfactory
> to me right now, but the testing we've done supports the patch.
> 
> The 2nd patch in the series is mostly cosmetic, and removes a
> redundant call to cpu_clear() that we no longer need().
> 
> Tony, if you agree with the rationale in 1/2, then this series is
> a candidate for .29.
> 
> stable team, if Tony pushes upstream for .29, then this series
> should be applied to the .27 and .28 stable series.

OK, I'll bite...

Why not use cpu_active_map rather than cpu_online_map to select which
CPU to migrate interrupts to?  That way, we can delay clearing the
bit in cpu_online_map and avoid the questionable scenario where irqs
are being handled by a CPU that appears to be offline.

							Thanx, Paul
