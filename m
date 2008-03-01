Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYCAFSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYCAFSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYCAFSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:18:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYCAFSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:18:16 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] firewire: fix crashes in workqueue jobs
Date: Sat, 1 Mar 2008 00:17:53 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
In-Reply-To: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803010017.53092.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008 12:56:10 pm Stefan Richter wrote:
> Here come 3 fixes + 2 cleanups.
>
>  1/5 firewire: invalid pointers used in fw_card_bm_work
>  2/5 firewire: fix crash in automatic module unloading
>  3/5 firewire: remove superfluous reference counting
>  4/5 firewire: fw-sbp2: fix reference counting
>  5/5 firewire: refactor fw_unit reference counting
>
> The main theme is that the firewire-core module has to stay loaded until
> after all workqueue jobs of the core and of protocol drivers have been
> finished.  This is accomplished by tracking the sum of references to
> instances of fw_device for each card.  (As a side effect, we don't need
> to count references to instances of fw_card anymore.)
>
>  drivers/firewire/fw-card.c        |   99
> ++++++++++++++++---------------------- drivers/firewire/fw-device.c      | 
>  21 ++------
>  drivers/firewire/fw-device.h      |   35 ++++++++++---
>  drivers/firewire/fw-ohci.c        |    8 +--
>  drivers/firewire/fw-sbp2.c        |    9 ++-
>  drivers/firewire/fw-topology.c    |    1
>  drivers/firewire/fw-transaction.h |    6 --
>  7 files changed, 89 insertions(+), 90 deletions(-)

Thumbs up for the whole series, with update 2 of the automatic module 
unloading swapped in for the original.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
