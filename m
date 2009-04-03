Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZDCBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZDCBJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZDCBJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:09:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40316 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZDCBJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:09:09 -0400
Date: Fri, 3 Apr 2009 02:09:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403010901.GB10545@srcf.ucam.org>
References: <200903291224.21380.info@gnebu.es> <200904030535.00335.nickpiggin@yahoo.com.au> <20090402183834.GB4773@srcf.ucam.org> <200904030556.41270.nickpiggin@yahoo.com.au> <20090402234751.GC9538@srcf.ucam.org> <alpine.DEB.1.10.0904021755250.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021755250.28893@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 05:59:53PM -0700, david@lang.hm wrote:

> is laptop mode
> 
> A. "write everything now, don't delay writes" in the hope that the drive 
> will be idle enough later to spin down

laptop-mode doesn't delay writes. Ever.

> or
> 
> B. "delay all writes until later, then when the drive wakes up do all 
> pending writes at that time" so that the drive can go to sleep in the 
> meantime?

Yes.

> I've heard things in these threads that would indicate both behaviors.

The code's pretty trivial. The only real functional differences 
laptop-mode brings are to write out all dirty pages (rather than just 
writing down to the watermark) and to call sys_sync() a few seconds 
after the last thing that hit disk rather than being satisfied from 
cache. It's entirely a mechanism to opportunistically take advantage of 
the disk being spun up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
