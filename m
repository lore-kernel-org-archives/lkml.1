Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbXLJR55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbXLJR55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXLJR5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:57:50 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:19018 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXLJR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:57:49 -0500
In-Reply-To: <OF85E31FAA.DADA6039-ONC12573AA.005439C8-C12573AA.005A132E@LocalDomain>
To: Arnd Bergmann <arnd@arndb.de>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Roland Dreier <rdreier@cisco.com>, Roland Dreier <rolandd@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF9AA24809.F691A5CC-ONC12573AD.006155D6-C12573AD.0062ABE2@de.ibm.com>
Date: Mon, 10 Dec 2007 18:59:16 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 10/12/2007 18:57:46,
	Serialize complete at 10/12/2007 18:57:46
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys,

> We're taking this to the firmware architects at the moment, but they're 
not 
> very fond of the idea of reporting the absence of bugs through 
capability 
> flags, as this could quickly lead to the exhaustion of flag bits. We'll 
let 
> the discussion stew for a bit, but if we don't get this flag, we'll have 
to 
> resort to the CPU features.

The architects have spoken, and we're getting a capability flag for this. 
I'll repost my patch with new autodetection code that doesn't involve 
checking the processor version.
 
> >  > Regarding the performance problem, have you checked whether 
converting all
> >  > your spin_lock_irqsave to spin_lock/spin_lock_irq improves your 
performance
> >  > on the older machines? Maybe it's already fast enough that way.
> > 
> > It does seem that the only places that the hcall_lock is taken also
> > use msleep, so they must always be in process context.  So you can
> > safely just use spin_lock(), right?
>
> As Arnd said, there are hCalls that will never return H_LONG_BUSY_*, 
such as 
> H_QUERY_PORT and chums, so they will never sleep. The surrounding 
functions, 
> though, are not prepared to be called from interrupt context (GFP_KERNEL 
comes
> to mind), so I agree that a simple spin_lock() will suffice. Thanks, 
Arnd, for
> pointing this out.

As I pointed out in my earlier mail, there's still an issue with 
map_phys_fmr possibly sleeping. Let's keep the irqsave for the time being 
and revisit this part once we find a solution to map_phys_fmr.

Regards,
  Joachim
