Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZIIBHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZIIBHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZIIBHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:07:47 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:36440 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZIIBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:07:44 -0400
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA - V3.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>
Cc: "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "eike-kernel@sf-tec.de" <eike-kernel@sf-tec.de>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "bvanassche@acm.org" <bvanassche@acm.org>,
       "robert.w.love@intel.com" <robert.w.love@intel.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
In-Reply-To: <412A05BA40734D4887DBC67661F433080FF72585@EXMAIL.ad.emulex.com>
References: <1252006675.18725.20.camel@ank32.eng.vmware.com>
	 <4AA03A9F.2040500@linux.vnet.ibm.com>
	 <412A05BA40734D4887DBC67661F433080FF72585@EXMAIL.ad.emulex.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 08 Sep 2009 18:07:47 -0700
Message-Id: <1252458467.24914.66.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chetan,

> Alok, 
> 
> (This is just a optimization.You don't need it in order to get your
> code merged upstream.You can always patch it later on)In fact hw_lock
> should be split into two locks - 
> 
> req_path_lock(aka tx_lock) and 
> cmpl_path_lock(aka rx_lock).
> 
> You can then have a full-duplex channel.
> 
> Revised-code - 
> 	::pvscsi_acquire_context->spin_lock_irqsave(tx_lock)
> 	::pvscsi_isr->spin_lock_irqsave(rx_lock)
> 	::some_future_napi_style_pvrx_poll_func->spin_lock_irqsave(rx_lock)
> 	
> 	::for aborts synchronize on the rx_lock so that you know what's
> completed and what's not.
> 

I agree about the optimization. Though IMO this will be more attractive
once we have a device which supports multiple queue pairs.
Anyways, let me keep this on my plate, I will check how much of an
benefit this gets us and will decide if this should be done, but as you
suggested this is for later.

Thanks for taking a look.

--Alok

> This is the kind of common code that should be provided by the bottom
> edge of the scsi-layer so that all the scsi-LLDD's can split their
> tx/rx paths!
> 



