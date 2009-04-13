Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZDMHni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZDMHni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZDMHnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:43:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:51655 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZDMHnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:43:10 -0400
Date: Mon, 13 Apr 2009 16:42:01 +0900
To: bharrosh@panasas.com
Cc: tj@kernel.org, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
 blk_rq_map_kern_sgl()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49D39DBC.3000206@panasas.com>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
	<1238593472-30360-15-git-send-email-tj@kernel.org>
	<49D39DBC.3000206@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090413164146J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Apr 2009 16:42:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 20:00:44 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 04/01/2009 04:44 PM, Tejun Heo wrote:
> > Impact: hack removal
> > 
> > SCSI needs to map sgl into rq for kernel PC requests; however, block
> > API didn't have such feature so it used its own rq mapping function
> > which hooked into block/bio internals and is generally considered an
> > ugly hack.  The private function may also produce requests which are
> > bigger than queue per-rq limits.
> > 
> > Block blk_rq_map_kern_sgl().  Kill the private implementation and use
> > it.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> James, TOMO
> 
> what happened to Tomo's patches that removes all this after fixing up
> all users (sg.c)?
> 
> I thought that was agreed and done? What is left to do for that to go
> in.

I've converted all the users (sg, st, osst). Nothing is left. So we
don't need this.
