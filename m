Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYFJIWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYFJIWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYFJIVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:21:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35831 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbYFJIVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:21:54 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>, Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH 0/2] Prevent loss of interrupts in IB/ehca
Date: Tue, 10 Jun 2008 10:21:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, TKLEIN@de.ibm.com,
       fenkes@de.ibm.com, raisch@de.ibm.com, THEMANN@de.ibm.com
References: <200806091742.29421.ossrosch@linux.vnet.ibm.com> <18509.44672.668946.207110@cargo.ozlabs.ibm.com>
In-Reply-To: <18509.44672.668946.207110@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101021.28795.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 00:28:16 Paul Mackerras wrote:
> Stefan Roscher writes:
> 
> > This patchset contains two changes for IB/ehca and ibmebus.
> > 
> > The first patch enables ibmebus_request_irq() to optionally return the 
> > IRQ number, which is used by the second patch to trigger EOI in case of 
> > lost interrupts.
> 
> At first sight it seems like a very bad idea for a driver to be poking
> into the internals of the interrupt subsystem like this.  Under what
> circumstances do interrupts get lost, and why does doing an extra EOI
> like this fix the problem?
> 
> Paul.
> 

The processing of events with a timer controlled polling is not the "typical"
way how you should handle adapter events.
During corner case testing, we noticed that some versions of ehca 
do not properly transition to interrupt done in special load situations.
This can be resolved by periodically triggering EOI through H_EOI, 
if eqes are pending.
Hope this clarifys the backround of the patch.

Is there a better way to initiate this type of EOI in a non-irq case?

regards Stefan R. and Christoph R.
