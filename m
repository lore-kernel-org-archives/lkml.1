Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZCRV45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZCRV45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbZCRVrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:47:09 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2239 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533AbZCRVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:47:07 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: High contention on the sk_buff_head.lock
From: "Eilon Greenstein" <eilong@broadcom.com>
To: "Vernon Mauery" <vernux@us.ibm.com>
cc: "Andi Kleen" <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <49C16294.8050101@us.ibm.com>
References: <49C12E64.1000301@us.ibm.com>
 <87prge1rhu.fsf@basil.nowhere.org> <49C16294.8050101@us.ibm.com>
Organization: Broadcom
Date: Wed, 18 Mar 2009 23:45:32 +0200
Message-ID: <1237412732.29116.2.camel@lb-tlvb-eliezer>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1
X-WSS-ID: 65DFB4433D45762408-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 14:07 -0700, Vernon Mauery wrote:
> > 
> > The real "fix" would be probably to use a multi queue capable NIC
> > and a NIC driver that sets up multiple queues for TX (normally they
> > only do for RX). Then cores or a set of cores (often the number
> > of cores is larger than the number of NIC queues) could avoid this
> > problem. Disadvantage: more memory use.
> 
> Hmmm.  So do either the netxen_nic or bnx2x drivers support multiple
> queues?  (that is the HW that I have access to right now).  And do I
> need to do anything to set them up?
> 
The version of bnx2x in net-next support multi Tx queues (and Rx). It
will open an equal number of Tx and Rx queues up to 16 or the number of
cores in the system. You can validate that all queues are transmitting
with "ethtool -S" which has per queue statistics in that version.

I hope it will help,
Eilon


