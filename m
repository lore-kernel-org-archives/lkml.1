Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbXLMIbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbXLMIbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXLMIbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:31:00 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:16927 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbXLMIbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:31:00 -0500
Message-ID: <4760EDC0.5020703@voltaire.com>
Date: Thu, 13 Dec 2007 10:30:56 +0200
From: Or Gerlitz <ogerlitz@voltaire.com>
User-Agent: Thunderbird 1.4.1 (Windows/20051006)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Joachim Fenkes <FENKES@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Christoph Raisch <raisch@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
References: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com><475FD0A1.3090304@voltaire.com> <adabq8v91co.fsf@cisco.com>
In-Reply-To: <adabq8v91co.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Dec 2007 08:30:57.0761 (UTC) FILETIME=[7C109510:01C83D62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> I think the right fix for iSER would be to make iSER work even for
> devices that don't support FMRs.  For example cxgb3 doesn't implement
> FMRs so if anyone ever updates iSER to work on iWARP and not just IB,
> then this is something that has to be tackled anyway.  Then ehca could
> just get rid of the FMR support it has.

OK, The iSER design took into account the case of many initiators 
running on strong/modern machines talking to possibly lightweight 
embedded target for which the processing cost per I/O at the target side 
should be minimized, that is at most --one-- RDMA operation should be 
issued by the target to serve an I/O request.

For that end, iSER works with one descriptor (called stag in iWARP and 
rkey in IB) per I/O direction sent from the initiator to the target and 
hence can't work without some sort of FMR implementation.

The current implementation of the open iscsi initiator makes sure to 
issue commands in thread (sleepable) context, see iscsi_xmitworker and 
references to it in drivers/scsi/libiscsi.c , so this keeps ehca users 
safe for the time being.

Or.



