Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbXLMTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbXLMTXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbXLMTWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:22:52 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:54136 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbXLMTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JP5Ta7igCFnaRneUFwNIGsURNqixgPvbtj+KCYAaebbPkhviziVgoMhUWGqbcreANEgpf1Npy3GpAqbmiZwHAQpSvHL5BqdNCq0COWZiyXdJCFnfhSk9cMXvhI1AWULL/HCHToVpUKINvj5w++LznqKa/3Ew+WpixVRDvtmpnAs=
Message-ID: <469958e00712131122s661dd970ud359389e1c6637d4@mail.gmail.com>
Date: Thu, 13 Dec 2007 11:22:49 -0800
From: "Caitlin Bestler" <caitlin.bestler@neterion.com>
To: "Or Gerlitz" <ogerlitz@voltaire.com>
Subject: Re: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
Cc: "Roland Dreier" <rdreier@cisco.com>, "Arnd Bergmann" <arnd@arndb.de>,
       "Joachim Fenkes" <FENKES@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       OF-General <general@lists.openfabrics.org>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
In-Reply-To: <4760EDC0.5020703@voltaire.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com>
	 <475FD0A1.3090304@voltaire.com> <adabq8v91co.fsf@cisco.com>
	 <4760EDC0.5020703@voltaire.com>
X-Google-Sender-Auth: ae6970e007976282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 12:30 AM, Or Gerlitz <ogerlitz@voltaire.com> wrote:
> Roland Dreier wrote:
> > I think the right fix for iSER would be to make iSER work even for
> > devices that don't support FMRs.  For example cxgb3 doesn't implement
> > FMRs so if anyone ever updates iSER to work on iWARP and not just IB,
> > then this is something that has to be tackled anyway.  Then ehca could
> > just get rid of the FMR support it has.
>
> OK, The iSER design took into account the case of many initiators
> running on strong/modern machines talking to possibly lightweight
> embedded target for which the processing cost per I/O at the target side
> should be minimized, that is at most --one-- RDMA operation should be
> issued by the target to serve an I/O request.
>
> For that end, iSER works with one descriptor (called stag in iWARP and
> rkey in IB) per I/O direction sent from the initiator to the target and
> hence can't work without some sort of FMR implementation.
>
> The current implementation of the open iscsi initiator makes sure to
> issue commands in thread (sleepable) context, see iscsi_xmitworker and
> references to it in drivers/scsi/libiscsi.c , so this keeps ehca users
> safe for the time being.
>
> Or.
>

I agree, *some* form of FMR support is important for iSER (and probably
for NFS over RDMA as well). Rather than adding a crippled NO FMR
mode it would make more sense to add support for FMR Work Requests.
I'm not certain what, if any, impact that would have on the Power5 problem,
but that's certainly a cleaner path for iWARP.
