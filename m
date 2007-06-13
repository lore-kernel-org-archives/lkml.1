Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbXFMQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbXFMQPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbXFMQPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:15:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293AbXFMQPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:15:37 -0400
Date: Wed, 13 Jun 2007 12:15:13 -0400
From: Dave Jones <davej@redhat.com>
To: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>, Eric Anholt <eric@anholt.net>
Subject: Re: I815 suddenly unkown to agpgart?
Message-ID: <20070613161513.GE3875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>,
	Eric Anholt <eric@anholt.net>
References: <Pine.SOC.4.64.0706131804180.2614@math> <20070613160152.GC3875@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613160152.GC3875@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:01:52PM -0400, Dave Jones wrote:
 > On Wed, Jun 13, 2007 at 06:07:42PM +0300, Meelis Roos wrote:
 >  > agpgart: Unsupported Intel chipset(device id: 1130)
 > 
 > This is likely due to 9614ece14f23f2ce54a076c471aec9c91e51e79c
 > 
 >     [AGPGART] intel_agp: use table for device probe
 >     
 >     Fixed issues noted by Christoph Hellwig, and I changed device table
 >     scan a bit to allow the case that some models of graphics chips may
 >     have same host bridge type. This type of chip will be added in the future.
 >     
 >     This patch cleans up device probe function. Eric Anholt was the original author.
 > 
 > Eric ?

Oh, we have this check in find_gmch ..

        if (gmch_device && PCI_FUNC(gmch_device->devfn) != 0) {
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Which isn't going to work, as Meelis has a gmch on device0, slot0, devfn1.
Meelis, does it start working again if you change that to just

	if (gmch_Device) {

?

	Dave

-- 
http://www.codemonkey.org.uk
