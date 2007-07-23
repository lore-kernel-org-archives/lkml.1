Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXGWNfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXGWNfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbXGWNfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:35:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54439 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760732AbXGWNfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:35:19 -0400
Subject: Re: [PATCH] LinuxPPS - definitive version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070717180550.GA24759@enneenne.com>
References: <20070717180550.GA24759@enneenne.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:35:16 +0100
Message-Id: <1185197716.14697.244.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 20:05 +0200, Rodolfo Giometti wrote:
> Hello,
> 
> here my last patch for PPS support.
> 
> In my opinion it should be ok for inclusion... please, let me know if
> something should be still changed.

s/Documentaion/Documentation/ in the last line of Documentation/pps/pps.txt

Please feed it to scripts/checkpatch.pl -- you can ignore all the
warnings about lines greater than 80 characters, and the complete crap
about "declaring multiple variables together should be avoided", but
some of what it points out is valid. Including the one about 'volatile'
-- your explanation lacked credibility. If you really need 'volatile'
then put it at the places you actually need it; not the declaration of
the structure. 

You've also reverted to structures which vary between 32-bit and 64-bit
userspace, because they use 'long' and 'struct timespec', but you
haven't provided the compat_* routines which are then necessary.

+typedef int pps_handle_t;              /* represents a PPS source */
+typedef unsigned long pps_seq_t;       /* sequence number */
+typedef struct ntp_fp ntp_fp_t;                /* NTP-compatible time stamp */
+typedef union pps_timeu pps_timeu_t;   /* generic data type to represent time s
tamps */
+typedef struct pps_info pps_info_t;    
+typedef struct pps_params pps_params_t;

Don't do this for the structures. It's dubious enough for the integer
types.

-- 
dwmw2

