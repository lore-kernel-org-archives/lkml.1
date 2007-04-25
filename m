Return-Path: <linux-kernel-owner+w=401wt.eu-S1423359AbXDYSTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423359AbXDYSTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423363AbXDYSTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:19:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:54949 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423359AbXDYSTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:19:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: pgprot_writecombine() and PATs on x86
Date: Wed, 25 Apr 2007 20:19:27 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       mst@mellanox.co.il, jackm@mellanox.co.il
References: <ada1wi8xrgt.fsf@cisco.com>
In-Reply-To: <ada1wi8xrgt.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252019.28017.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 20:02:26 Roland Dreier wrote:
> Hi Eric,
> 
> Where do your patches to add an implementation of
> pgprot_writecombine() using PATs on x86 stand?  

It's on my todo list.

> The mlx4 driver I'm 
> planning on merging for 2.6.22 would really like writecombining, and
> I'm interested in doing the work to finally get the PAT stuff merged
> (probably for 2.6.23 I guess).
> 
> Just to give a little background on my motivation: the mlx4 hardware
> allows a page in its PCI space to be mapped, where the driver can write
> descriptors and payloads directly, instead of ringing a doorbell and
> having the HW fetch the descriptor from system memory, for better latency.

When it's PCI space you can likely just use MTRRs. PAT is mostly useful
for applications that do IO with random memory pages

-Andi
