Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZFZSAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZFZSAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZFZSAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:00:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51360 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZFZSAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:00:47 -0400
Date: Fri, 26 Jun 2009 14:00:42 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090626180042.GC7337@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625163050.d6a71a13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:30:50PM -0700, Andrew Morton wrote:
<snip>

Ok, heres a new version of the changeset, taking into account all of your notes,
Andrew. Patches tested by me on a kernel with your latest -mm patch and it all
works well.

This resolves kernel.org bug 13355:
http://bugzilla.kernel.org/show_bug.cgi?id=13355

Change Notes:

1) Split the patch into two smaller patches.  I kept the sysctl with the wait
code for the reasons we discussed earlier.

2) core_dump_count is now statically declared within the scope of the
do_coredump function

3) Commented more clearly the use of the task_tgid_vnr call

4) Made the printk indicating that a crash is over the core dump limit more
usefull

5) Fixed some misc. gramatical, formatting errors

6) Removed the helper_pid variable.  Turns out it wasn't needed with a minor
change to the usermodehelper code.

7) Documented the sysctl in Documentation/sysctl/kernel.txt

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>
 
