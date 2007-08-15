Return-Path: <linux-kernel-owner+w=401wt.eu-S937053AbXHOWmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937053AbXHOWmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761060AbXHOWlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:41:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:59434 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934667AbXHOWlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:41:50 -0400
Date: Thu, 16 Aug 2007 00:41:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Wilder <dwilder@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       martin.schwidefsky@de.ibm.com
Subject: Re: [patch] s390 kprobe fix instruction length calculation
Message-ID: <20070815224147.GB8741@osiris.ibm.com>
References: <46C370BC.40302@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C370BC.40302@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 02:31:40PM -0700, David Wilder wrote:
> Placing a kprobe on "bc" instruction (s390/s390x) can cause an oops.
> The instruction length is encoded into the first two bits of the s390 
> instruction.  Kprobe is incorrectly computing the instruction length.
> The instruction length is used for determining what type of "fix-up" is 
> needed for conditional branch instruction.  The problem can bee seen by 
> placing a kprobe on a  "bc" instruction that will not branch.   The results 
> is that  Kprobe incorrectly computes the  new instruction pointer 
> (psw.addr) after single stepping the instruction.   The problem is 
> corrected with this patch.
>
>  	/* save the instruction length (pop 5-5) in bytes */
> -	switch (*(__u8 *) (ainsn->insn) >> 4) {
> +	switch (*(__u8 *) (ainsn->insn) >> 6) {
>  	case 0:

Added to the s390 patch queue. Thanks! :)
