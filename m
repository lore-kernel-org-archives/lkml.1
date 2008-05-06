Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbYEFUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbYEFUnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYEFUnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:43:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51602 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbYEFUnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:43:05 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080506202201.GB12654@escobedo.amd.com>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
	 <20080506124946.GA2146@elte.hu>
	 <Pine.LNX.4.64.0805061435510.32567@blonde.site>
	 <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0805062043580.11647@blonde.site>
	 <20080506202201.GB12654@escobedo.amd.com>
Content-Type: text/plain
Date: Tue, 06 May 2008 13:42:59 -0700
Message-Id: <1210106579.4747.51.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 22:22 +0200, Hans Rosenfeld wrote:
> I expected that any hugepage that a process had mmapped would
> automatically be returned to the system when the process exits. That was
> not the case, the process exited and the hugepage was lost (unless I
> changed the program to explicitly munmap the hugepage before exiting).
> Removing the hugetlbfs file containing the hugepage also didn't free the
> page.

Could you post the code you're using to do this?  I have to wonder if
you're leaving a fd open somewhere.  Even if you rm the hugepage file,
it'll stay allocated if you have a fd open, or if *someone* is still
mapping it. 

Can you umount your hugetlbfs?

-- Dave

