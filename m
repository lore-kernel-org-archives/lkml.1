Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYEANRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYEANRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYEANRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:17:09 -0400
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:58685 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYEANRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:17:08 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] KVM x86: Handle hypercalls for assigned PCI devices
Date: Thu, 1 May 2008 18:48:28 +0530
User-Agent: KMail/1.9.9
Cc: kvm-devel@lists.sourceforge.net, virtualization@lists.linux-foundation.org,
       muli@il.ibm.com, BENAMI@il.ibm.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <48173440.304@redhat.com> <200804292128.52268.amit.shah@qumranet.com>
In-Reply-To: <200804292128.52268.amit.shah@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011848.29363.amit.shah@qumranet.com>
X-OriginalArrivalTime: 01 May 2008 13:17:06.0618 (UTC) FILETIME=[A75541A0:01C8AB8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 21:28:51 Amit Shah wrote:
> On Tuesday 29 April 2008 20:14:16 Glauber Costa wrote:
> > Amit Shah wrote:

> > > +	if (find_pci_pt_dev(&vcpu->kvm->arch.pci_pt_dev_head,
> > > +			    &pci_pt_info, 0, KVM_PT_SOURCE_ASSIGN))
> > > +		r++; /* We have assigned the device */
> > > +
> > > +	kunmap(host_page);
> >
> > better use atomic mappings here.
>
> We can't use atomic mappings for guest pages. They can be swapped out.

Actually you were right: there's no sleeping call here after doing the 
mapping. I've updated this call with kmap_atomic.

The other function that uses kmap can't be converted since we continue to map 
several pages in a loop (depending on the length of the DMA region) and hence 
can't use kmap_atomic there.
