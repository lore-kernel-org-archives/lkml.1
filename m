Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbXGOKV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbXGOKV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXGOKVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:21:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbXGOKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:21:45 -0400
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
From: Peter Zijlstra <peterz@infradead.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20070713214746.GH23255@mami.zabbo.net>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
	 <1184333621.20032.85.camel@twins>
	 <20070713121259.20066d5b.akpm@linux-foundation.org>
	 <20070713214746.GH23255@mami.zabbo.net>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 12:21:21 +0200
Message-Id: <1184494881.5284.92.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 14:47 -0700, Zach Brown wrote:

> Peter, do you have any interest in seeing how far we can get
> at tracking lock_page()?  I'm not holding my breath, but any little bit
> would probably help.

I ran headfirst into the fact the unlock_page() need not be called by
the same task that did lock_page().

Esp IO-completion interrupts love to unlock pages they did not lock
themselves. Not at all sure that is fixable, it seems to be the nature
of the async structure of the problem :-(



