Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZH1WOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZH1WOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZH1WOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:14:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57117 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751764AbZH1WOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:14:46 -0400
Date: Fri, 28 Aug 2009 23:16:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without
 PAE
Message-ID: <20090828231603.7918be05@lxorguk.ukuu.org.uk>
In-Reply-To: <205.26101.qm@web45216.mail.sp1.yahoo.com>
References: <20090828205337.3677cf04@lxorguk.ukuu.org.uk>
	<205.26101.qm@web45216.mail.sp1.yahoo.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> I understand the implications of reloading CR3. But once the page tables are  setup to map all the available physical RAM to virtual (linear) address it could be for eg. 1, 2, 3 or 4 GB how does it matter.

Where are you putting the user virtual addresses. User addresses don't
map direct to physical addresses so you need both sets of translations at
once

Right now you have

0-3GB		MMU translations to arbitary basically random
physical addresses (with many pages shared and some absent)

3GB+		Physical mapping only accessible in kernel mode

If user applications ran with a 1:1 mapping of application space to
physical addresses you would be fine - but they don't and it would be
rather hard to run like that because you want page sharing, lazy unshare,
vfork etc to all work.
