Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZJVOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZJVOlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZJVOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:41:16 -0400
Received: from fmmailgate07.web.de ([217.72.192.248]:64744 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbZJVOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:41:16 -0400
Date: Thu, 22 Oct 2009 16:41:19 +0200
Message-Id: <1395936298@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
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
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/bbTw3/57BI1tOOyXVvQxli9Yi1dKqaX4hoML+fbVmjxAiV
 Igd25rzpJvyUIEh7/GtICxSIzU+yDcdRDDKVDAhT82wyiIhpT1JFYYtX798w
 A==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> > > There is no need to go through num_var_ranges etc.
> > 
> > Well I have to remember wich file added which MTRR entries. Because I have
> > to remove them if the file is being closed. Therefore I need an array of size
> > "num_var_ranges" (or MTRR_MAX_VAR_RANGES which is the uper bound).
> 
> No. the private data  for example can keep track of a struct containing
> mtrr number and ref count etc. Exporting var_ranges and going through
> var ranges elements in an array is not clean, especially when you are
> populating only one element.

OK, I should have written that num_var_ranges is neccessary if I do copy a
algorithm for exactly the same purpose from an other place. And I don't see
anything better in having a dynamically growing list that makes the operation
of incrementing MTRR entries an O(n) operation where it now is a O(1) operation.

Additionally, the worst case memory requirement would be
2*sizeof(int)*num_var_ranges, where it is now 1*sizeof(int)*num_var_ranges.

So for me, this would be a step back, but if you want this, you should additionally
change arch/x86/kernel/cpu/mtrr/if.c from where I reused the algorithm.

Regards,
  Thomas
