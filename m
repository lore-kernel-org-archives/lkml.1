Return-Path: <linux-kernel-owner+w=401wt.eu-S965996AbXCFSfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996AbXCFSfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965995AbXCFSfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:35:24 -0500
Received: from ns1.suse.de ([195.135.220.2]:43354 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965997AbXCFSfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:35:22 -0500
Date: Tue, 6 Mar 2007 20:34:45 +0100
From: Andi Kleen <ak@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
Message-ID: <20070306193445.GI22829@bingen.suse.de>
References: <1173184747.4644.23.camel@localhost.localdomain> <1173185592.4644.28.camel@localhost.localdomain> <1173185666.4644.30.camel@localhost.localdomain> <1173185734.4644.32.camel@localhost.localdomain> <1173185827.4644.34.camel@localhost.localdomain> <1173185909.4644.36.camel@localhost.localdomain> <1173186021.4644.38.camel@localhost.localdomain> <1173186107.4644.41.camel@localhost.localdomain> <1173186214.4644.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173186214.4644.44.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sigh -- i had hoped this had settled down because it was a
merging nightmare last time. Ok. 

> +#define percpu_to_op(op,var,val)				\
> +	do {							\
> +		typedef typeof(var) T__;			\
> +		if (0) { T__ tmp__; tmp__ = (val); }		\
> +		switch (sizeof(var)) {				\
> +		case 1:						\
> +			asm(op "b %1,"__percpu_seg"%0"		\
> +			    : "+m" (var)			\
> +			    :"ri" ((T__)val));			\

Perhaps I'm blind but I can't see where the %fs reference is there.
How does this work? 

Do you have text size comparisons before/after and possible lmbench? 

-Andi
