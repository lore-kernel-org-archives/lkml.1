Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZFDQuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZFDQuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZFDQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:49:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:59723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZFDQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:49:55 -0400
Message-ID: <4A27FAD4.2010104@kernel.org>
Date: Thu, 04 Jun 2009 09:48:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, mel@csn.ul.ie,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, steiner@sgi.com,
       rientjes@google.com
Subject: Re: [RESEND PATCH] mm: clear N_HIGH_MEMORY map before se set it again
 -v2
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie> <4A0A64FB.4080504@kernel.org> <20090513145950.GB28097@csn.ul.ie> <4A0C4910.7090508@kernel.org> <4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org> <4A0C4F67.5080802@kernel.org> <20090514102554.b3a36f19.akpm@linux-foundation.org> <4A0C563A.3020100@kernel.org> <4A2758CB.9090404@kernel.org> <alpine.DEB.1.10.0906041236520.5377@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906041236520.5377@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Ok. The N_HIGH_MEMORY bit is set for all onlines nodes in a loop
> that follows the code you modified. The patch insures that bits do not
> remain set that earlier arch / core code may have set.
> 
> Could you make the description clearer?
> 

how about

Subject: [PATCH] mm: clear N_HIGH_MEMORY map before se set it again -v3

in case some system strange SRAT table. some kind of small range form some node
or with mem= boot option etc. that node will not be onlined.  
In the early checking, the bit in node_states[N_HIGH_MEMORY] for the
node is set even that node has less RAM like 1M.

The N_HIGH_MEMORY bit is set for all onlines nodes in a loop that follows the 
code that is modified. The patch insures that bits do not remain set that 
earlier arch / core code may have set.

for 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too

v3: update description according to Christoph

