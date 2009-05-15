Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZEOSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZEOSWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZEOSWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:22:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47047 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZEOSWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:22:12 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0905151358430.26559@qirst.com>
References: <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
	 <1242333519.15391.210.camel@nimitz>
	 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
	 <1242335120.15391.242.camel@nimitz>
	 <alpine.DEB.1.10.0905141729180.30187@qirst.com>
	 <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz>
	 <20090515130547.GA1976@elf.ucw.cz>
	 <alpine.DEB.1.10.0905151358430.26559@qirst.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 11:22:07 -0700
Message-Id: <1242411727.28257.39.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 13:59 -0400, Christoph Lameter wrote:
> On Fri, 15 May 2009, Pavel Machek wrote:
> > Ok, so kernel should be fixed to make limits 30% of non-mlocked
> > memory.
> 
> There is already ulimit.

There is, but it gets overridden anyway since there are users that
"need" tons of mlock() space.  We also shouldn't be allowing things to
get into crazy configurations.  Having a max dirty ratio doesn't even
have an effect when you can dirty all unlocked memory several times over
and still not be hitting the max dirty mark.

Perhaps we should ensure that total RAM mlock()ed + vm_dirty_bytes is
always under total ram.  That'll force people to either stop mlocking or
do the safe thing which is drop vm_dirty_bytes.  

-- Dave

