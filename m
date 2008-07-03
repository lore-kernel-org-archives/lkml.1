Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYGCSAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYGCSAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYGCSAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:00:05 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:34730 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYGCSAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:00:03 -0400
X-BigFish: VPS-23(zz98dR7efVzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3FZBH-02-RQ3-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/6] AMD IOMMU: flush domain TLB when there is more than onepage to flush
Date: Thu, 3 Jul 2008 13:01:21 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273013D91CF@sausexmb4.amd.com>
In-Reply-To: <1215106511-12915-4-git-send-email-joerg.roedel@amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/6] AMD IOMMU: flush domain TLB when there is more than onepage to flush
Thread-Index: AcjdM43RxO4320PASnuxIq1jBk1D0QAAh92A
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com> <1215106511-12915-4-git-send-email-joerg.roedel@amd.com>
From: "Duran, Leo" <leo.duran@amd.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>, <mingo@redhat.com>,
       <tglx@linutronix.de>
CC: "Richter, Robert" <rrichter@elbe.amd.com>,
       <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:59:51.0268 (UTC) FILETIME=[9713AA40:01C8DD36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 03, 2008 12:35 PM, Joerg Roedel wrote:

> This patch changes the domain TLB flushing behavior of the driver.
When
> there
> is more than one page to flush it flushes the whole domain TLB instead
> of every
> single page. So we send only a single command to the IOMMU in every
> case which
> is faster to execute.
> 

Joerg,

Instead of flushing the complete TLB, how about just setting the
page-size encoding bits so as to cover all of the pages (rounded up to a
power of 2... which in some cases may flush a few more pages, but not
the complete TLB). This way other devices don't pay the 'flushing'
penalty every time you unmap a buffer for a given device.

Leo.

