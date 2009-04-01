Return-Path: <linux-kernel-owner+w=401wt.eu-S1764367AbZDARFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764367AbZDARFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZDARFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:05:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35234 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbZDARFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:05:41 -0400
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <49D39DBC.3000206@panasas.com>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
	 <1238593472-30360-15-git-send-email-tj@kernel.org>
	 <49D39DBC.3000206@panasas.com>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 17:05:38 +0000
Message-Id: <1238605538.3318.63.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 20:00 +0300, Boaz Harrosh wrote:
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

They couldn't go in because they would break libosd.  You were going to
send patches to fix libosd so it no longer relied on the exported
function ... did that happen and I missed it?

James


