Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYCCM2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYCCM2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYCCM2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:28:30 -0500
Received: from styx.suse.cz ([82.119.242.94]:38162 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375AbYCCM23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:28:29 -0500
Date: Mon, 3 Mar 2008 13:28:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Olsa <olsajiri@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
In-Reply-To: <47CBECB8.7040605@gmail.com>
Message-ID: <Pine.LNX.4.64.0803031324200.15209@jikos.suse.cz>
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
 <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz>
 <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz> <47CBE871.4090309@gmail.com>
 <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz> <47CBECB8.7040605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Jiri Olsa wrote:

> ipcs.kernel.out.1 is the kernel log from the time strace ipcs was done.
> ipcs.kernel.out.2 is from the next run of ipcs that stuck,
> there's no overlay between those logs.
> When the kernel freeze I'm getting logs with the spinlock lockup.. and it's repeating.

Thanks. Have you tried turning lockdep off, if that still triggers?

Aparently the first BUG leaves the spin lock locked, and all subsequent 
accessess to it lock the machine hard. We'll need to see what goes wrong 
inside lockdep.

Could you please run

	addr2line -e vmlinux c0133034

(passing the path to the vmlinux binary of the crashing kernel to the -e 
parameter).

-- 
Jiri Kosina
SUSE Labs
