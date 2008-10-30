Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYJ3WCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYJ3WCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYJ3WCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:02:36 -0400
Received: from uni13mr.unity.ncsu.edu ([152.1.224.171]:34697 "EHLO
	uni13mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYJ3WCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:02:36 -0400
X-Greylist: delayed 755 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 18:02:35 EDT
Message-ID: <1819.152.14.92.134.1225403398.squirrel@webmail.ncsu.edu>
Date: Thu, 30 Oct 2008 17:49:58 -0400 (EDT)
Subject: Question about page frame management in x86_64
From: "Emre Can Sezer" <ecsezer@ncsu.edu>
To: linux-kernel@vger.kernel.org
Cc: ecsezer@ncsu.edu
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.313940, Antispam-Data: 2008.10.30.213114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For my research I'm trying to keep track of which pages belong to an LKM.
I use linux-2.6.26.

When the module is first loaded, the virtual memory region (ffff ffff a000
0000) maps to a set of page frames, which I track.  Later on (after all
the modules have loaded), these same pages are returned by
get_free_pages(), before they are released.  At this point, the page table
entries have also changed.  I observe this for all modules.  Since the
modules haven't exited, I can only assume that the pages are relocated. 
However, neither free_more_memory() is called nor balance_pgdat() reclaims
any pages.  They aren't freed via any of the __free_pages() family of
functions either.  What could be relocating these pages and which
functions would be responsible for it?

Thanks in advance,

John

PS.  I'm not subscribed to the mailing list, so please CC to me.  Thanks.
