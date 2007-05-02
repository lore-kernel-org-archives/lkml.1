Return-Path: <linux-kernel-owner+w=401wt.eu-S2993055AbXEBLFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993055AbXEBLFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993054AbXEBLFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:05:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:47159 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993059AbXEBLFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:05:51 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH] [28/34] i386: pte xchg optimization
Date: Wed, 2 May 2007 13:05:40 +0200
User-Agent: KMail/1.9.6
Cc: zach@vmware.com, linux-kernel@vger.kernel.org, patches@x86-64.org
References: <20070430549.617098000@suse.de> <20070430155001.8525915209@wotan.suse.de> <463889A9.76E4.0078.0@novell.com>
In-Reply-To: <463889A9.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021305.40525.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I always wondered why the xchg is necessary here at all. If the process of
> tearing down a page table entry has started, other users of the mapped
> linear address are broken anyway - why is it necessary to still monitor the
> effect they may have on the A/D bits, unless this is a transient tear down?
> 
> Checking for the uses of ptep_get_and_clear, I would judge that the use in
> change_pte_range() may in fact need the xchg, but the uses in
> vunmap_pte_range() and zap_pte_range() shouldn't.

Yes I agree. Might be a nice speed up for exit to distingush the cases.

-Andi
