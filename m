Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbYFIWvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbYFIWvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFIWvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:51:36 -0400
Received: from ozlabs.org ([203.10.76.45]:60342 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbYFIWvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:51:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18509.44672.668946.207110@cargo.ozlabs.ibm.com>
Date: Tue, 10 Jun 2008 08:28:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       general@lists.openfabrics.org, "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, TKLEIN@de.ibm.com,
       fenkes@de.ibm.com, raisch@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH 0/2] Prevent loss of interrupts in IB/ehca
In-Reply-To: <200806091742.29421.ossrosch@linux.vnet.ibm.com>
References: <200806091742.29421.ossrosch@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Roscher writes:

> This patchset contains two changes for IB/ehca and ibmebus.
> 
> The first patch enables ibmebus_request_irq() to optionally return the 
> IRQ number, which is used by the second patch to trigger EOI in case of 
> lost interrupts.

At first sight it seems like a very bad idea for a driver to be poking
into the internals of the interrupt subsystem like this.  Under what
circumstances do interrupts get lost, and why does doing an extra EOI
like this fix the problem?

Paul.
