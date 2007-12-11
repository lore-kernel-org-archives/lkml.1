Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbXLKIhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbXLKIhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXLKIhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:37:32 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:31382 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXLKIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:37:31 -0500
In-Reply-To: <adahciq9q86.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Raisch <raisch@de.ibm.com>,
       OF-EWG <ewg@lists.openfabrics.org>,
       OF-General <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com>
Date: Tue, 11 Dec 2007 09:38:58 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 11/12/2007 09:37:28,
	Serialize complete at 11/12/2007 09:37:28
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 10.12.2007 22:47:37:

> It's a big problem.  If you cannot implement FMRs in such a way that
> you can handling having map_phys_fmr being called in a context that
> can't sleep, then I think the only option is to remove your FMR
> support.

That's kind of what I feared you would say =)

> It's an optional device feature, so this should be OK
> (although the iSER driver currently seems to depend on a device
> supporting FMRs, which is probably going to be a problem with iWARP
> support in the future anyway).

I don't feel very well with removing code from the driver that iSER seems 
to depend on. Are there plans to fix this in iSER?

In reality, PHYP rarely ever returns H_LONG_BUSY, and we haven't had any 
problems with iSER in the field yet. I admit that our FMR code is 
dangerous, but I prefer "dangerous but working for the customer" over "not 
working for the customer at all".
 
Maybe we can agree on keeping the status quo until no more ULPs depend on 
FMR, then remove FMR from ehca? If so, we'd also let the _irqsave 
spinlocks around hCalls stay in place.

Regards,
  Joachim
