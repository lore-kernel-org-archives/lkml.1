Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYJFF4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYJFF4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYJFF4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:56:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38049 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJFF4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:56:40 -0400
Date: Mon, 6 Oct 2008 08:02:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #11569] Don't complain about disabled irqs when the system has paniced
Message-ID: <20081006060238.GB3180@one.firstfloor.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.qTH.6475IB@wind>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yWwteD.A.qTH.6475IB@wind>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 07:32:54PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
> Subject		: Don't complain about disabled irqs when the system has paniced
> Submitter	: Andi Kleen <andi@firstfloor.org>
> Date		: 2008-09-02 13:49 (33 days old)
> References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4

The problem is actually worse than this description suggests. I updated
the bugzilla entry now.

The new smp_call_function() that is called from panic is quite unsuitable
for this task:
- It allocates memory (not a good idea in panic0
- It complains about interrupt off
- This whole thing breaks at least machine checks

-Andi

-- 
ak@linux.intel.com
