Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXGCFvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXGCFvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXGCFvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:51:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:47602 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXGCFvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:51:35 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 15:51:27 +1000
Message-Id: <1183441887.10386.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> a screaming nightmare - either the suspend fails because syslog (for 
> instance) can't be frozen, or the machine deadlocks for some other 
> reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> could do what we do for suspend to RAM on other platforms (PPC and APM) 
> and just not use the freezer.

The main reason for deadlocks is because we do a sys_sync() after the
freeze, which we shouldn't do.

Ben.


