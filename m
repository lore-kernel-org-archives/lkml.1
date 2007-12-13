Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXLMVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXLMVAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763623AbXLMU74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:59:56 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:2958 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763384AbXLMU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:59:54 -0500
In-Reply-To: <469958e00712131122s661dd970ud359389e1c6637d4@mail.gmail.com>
To: "Caitlin Bestler" <caitlin.bestler@neterion.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, caitlin.bestler@gmail.com,
       OF-General <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       "Or Gerlitz" <ogerlitz@voltaire.com>,
       "Roland Dreier" <rdreier@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related
 hCalls on POWER5
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD5B7D5E6.3538DC2A-ONC12573B0.0072D42A-C12573B0.00735730@de.ibm.com>
Date: Thu, 13 Dec 2007 21:59:50 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 13/12/2007 21:59:51,
	Serialize complete at 13/12/2007 21:59:51
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caitlin.bestler@gmail.com wrote on 13.12.2007 20:22:49:

> On Dec 13, 2007 12:30 AM, Or Gerlitz <ogerlitz@voltaire.com> wrote:
> > The current implementation of the open iscsi initiator makes sure to
> > issue commands in thread (sleepable) context, see iscsi_xmitworker and
> > references to it in drivers/scsi/libiscsi.c , so this keeps ehca users
> > safe for the time being.

> I agree, *some* form of FMR support is important for iSER (and probably
> for NFS over RDMA as well). Rather than adding a crippled NO FMR
> mode it would make more sense to add support for FMR Work Requests.
> I'm not certain what, if any, impact that would have on the Power5 
problem,
> but that's certainly a cleaner path for iWARP.

Well, FMR WRs wouldn't change the eHCA issue -- the driver would have to 
make an hCall in any case, and the architecture says that the hCalls used 
in this scenario might return H_LONG_BUSY, causing the driver to sleep. No 
way around that. Because of this, eHCA's FMRs are actually standard MRs 
with a different API.

If, as Or said, the iSCSI initiator issues commands in sleepable context 
anyway, nothing would be lost by using standard MRs as a fallback solution 
if FMRs aren't available, would it?

J.

