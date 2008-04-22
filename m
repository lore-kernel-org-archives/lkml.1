Return-Path: <linux-kernel-owner+w=401wt.eu-S1763725AbYDVNLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763725AbYDVNLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763534AbYDVNKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:10:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763527AbYDVNKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:10:38 -0400
Date: Tue, 22 Apr 2008 15:10:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Message-ID: <20080422131020.GB7311@elte.hu>
References: <20080419085758.GA18612@elte.hu> <1208611357.3280.5.camel@localhost.localdomain> <20080421134925.GK9554@elte.hu> <1208793440.3640.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208793440.3640.22.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Thanks ... it looks like we may have trouble from devices that alter 
> the unchecked isa dma flag after scsi_host_alloc.  The guilty parties 
> appear to be gdth, eata, u14-34f, ultrastor, BusLogic and advansys.
> 
> The trouble is that if you alloc the host with it one way and free it 
> with it the other, the wrong freelist is used and the ref counts are 
> invalid.
> 
> Try this pseudo fix: it avoids allocating the freelist until add time 
> (by which time they should all have fixed the flag).  It still doesn't 
> change the fact that the host is allocated in the wrong region, but 
> that shouldn't matter too much.

ok - do you intend to push this pseudo-fix upstream? If yes then please 
consider it fixed as far as i'm concerned - i'll re-reply if the warning 
resurfaces (it wasnt lethal to the bootup otherwise). Or if you've got 
some other approach/fix then i can test that too.

	Ingo
