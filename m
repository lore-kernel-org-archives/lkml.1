Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZAIOGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZAIOGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 09:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZAIOG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 09:06:28 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:50901 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbZAIOG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 09:06:27 -0500
Date: Fri, 09 Jan 2009 23:06:26 +0900 (JST)
Message-Id: <20090109.230626.126760668.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090105.230230.132760259.anemo@mba.ocn.ne.jp>
References: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
	<20090105.230230.132760259.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 23:02:30 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Mon, 29 Dec 2008 23:39:32 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > Hi.  I'm writing a new DMA driver, using dw_dmac driver in kernel
> > 2.6.28 as a reference implementation.
> > 
> > I can see an outline of the dw_dmac driver and framework (well,
> > hopefully), but have some questions in details.
> 
> One more.

One more again.

5. dwc_issue_pending()

Is this needed?  The dwc_tx_submit might queue the descriptor, but it
should be issued automatically after completion of all descriptors in
active list.

It yes, it seems implementation like this would be possible:

* dwc_tx_submit() just always add the descriptor to queue list even if
  active list was empty.

* dwc_issue_pending() call dwc_dostart() and move queued descriptor(s)
  to active list, if the active list was empty.

But I'm not sure "chain as many as possible at a time" is really
better then "start engine as soon as possible".

---
Atsushi Nemoto
