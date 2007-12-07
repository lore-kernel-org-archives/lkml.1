Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXLGW0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXLGW0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXLGWZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:25:53 -0500
Received: from a-sasl-quonix.pobox.com ([208.72.237.25]:41032 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbXLGWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:25:53 -0500
X-Greylist: delayed 853 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2007 17:25:53 EST
Date: Fri, 7 Dec 2007 16:11:06 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Message-ID: <20071207221106.GH16824@localdomain>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir-

Balbir Singh wrote:
> 
> 
> Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
> NUMA nodes can be specified using the following command line option
> 
> numa=fake=<node range>
> 
> node range is of the format <range1>,<range2>,...<rangeN>
> 
> Each of the rangeX parameters is passed using memparse(). I find the patch
> useful for fake NUMA emulation on my simple PowerPC machine. I've tested it
> on a non-numa box with the following arguments
> 
> numa=fake=1G
> numa=fake=1G,2G
> name=fake=1G,512M,2G
> numa=fake=1500M,2800M mem=3500M
> numa=fake=1G mem=512M
> numa=fake=1G mem=1G

So this doesn't appear to allow one to assign cpus to fake nodes?  Do
all cpus just get assigned to node 0 with numa=fake?

A different approach that occurs to me is to use kexec with a doctored
device tree (i.e. with the ibm,associativity properties modified to
reflect your desired topology).  Perhaps a little bit obscure, but it
seems more flexible.

