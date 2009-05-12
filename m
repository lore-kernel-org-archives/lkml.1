Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbZELHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbZELHK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZELHKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:10:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57663 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZELHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:10:17 -0400
Date: Tue, 12 May 2009 09:15:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090512071531.GF19296@one.firstfloor.org>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0894A5.9000209@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should it?  It seems to me that CPUs 0-1 should be antipreferentially 
> scheduled, 

You could do that, but the question is if it matters. It would
only make a difference on systems which are not fully loaded, 
and it's unclear how much.

And at some point you need to use these cores anyways; usually it's much
worse to not use a CPU and overload others than to use it with slower memory.

Is it worth adding a lot of fixes all over hte kernel? Not clear
to me.

Also it's a obscure situation and it affects a lot of code, so you
would likely have to continuously fight with regressions as Jack
has discovered.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
