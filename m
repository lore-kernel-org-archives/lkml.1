Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZJVN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZJVN6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZJVN6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:58:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:46259 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbZJVN6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,605,1249282800"; 
   d="scan'208";a="202194904"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Jan Beulich <JBeulich@novell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1395763521@web.de>
References: <1395763521@web.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 22 Oct 2009 06:35:50 -0700
Message-Id: <1256218550.2546.18.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 05:08 -0700, Thomas Schlichter wrote:
> When forking, what happens with the "struct file"? If it is being copied, then the
> processes share the same private data which would be freed during the first
> release(). I think this would be a problem whereever file-private data are used.
> 
> So I think it must be shared between the forked processes and some reference
> counting must exist. This reference counting must ensure that release() is only
> called when all processes did close() their file.
> 
> And in that case (shared "struct file", one single release() call in the end) this
> implementation should be completely safe...

I am referring to the refcount getting incremented. Also, let me think
about your direction (as the pci_mmap_page_rane() is explicitly adding
the mtrr, we should perhaps do the ref counting there, perhaps)

> > There is no need to go through num_var_ranges etc.
> 
> Well I have to remember wich file added which MTRR entries. Because I have
> to remove them if the file is being closed. Therefore I need an array of size
> "num_var_ranges" (or MTRR_MAX_VAR_RANGES which is the uper bound).

No. the private data  for example can keep track of a struct containing
mtrr number and ref count etc. Exporting var_ranges and going through
var ranges elements in an array is not clean, especially when you are
populating only one element.

thanks
suresh

