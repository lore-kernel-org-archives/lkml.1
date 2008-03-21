Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYCUS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYCUS6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYCUS6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:58:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbYCUS6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:58:45 -0400
Date: Fri, 21 Mar 2008 19:58:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, shai@scalex86.org
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched
	TSC's on multiboard vSMP systems
Message-ID: <20080321185821.GE6571@elte.hu>
References: <20080320073740.GA9414@localdomain> <20080320074508.GE9414@localdomain> <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com> <20080320190240.GB6085@localdomain> <20080321091542.GE20420@elte.hu> <20080321185225.GA23139@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321185225.GA23139@localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> As for the observation about probing the pci space early during the 
> bootup, we call vsmp_init() much earlier during the bootup, which 
> calls is_vsmp_box(), does the pci probing and caches the result in the 
> flag, as you suggest. So the call in the above diff context does not 
> access the pci config space as is.

ah, i see - indeed - the trick with -1 :-)

my point remains though: if you initialize VSMP in a separate function 
anyway then please move this PCI config space access from is_vsmp_box() 
into vsmp_init() and keep a pure flag return is_vsmp_box(). That way 
there can be no question at all whether there are (or can be) any 
side-effects of that function.

	Ingo
