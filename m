Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZJSO74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZJSO74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZJSO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:59:55 -0400
Received: from fmmailgate06.web.de ([217.72.192.247]:33564 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbZJSO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:59:54 -0400
X-Greylist: delayed 767 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 10:59:54 EDT
Date: Mon, 19 Oct 2009 16:59:57 +0200
Message-Id: <1392906098@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Jan Beulich <JBeulich@novell.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: arjan@linux.intel.com, dri-devel@lists.sourceforge.net,
       hancockrwd@gmail.com, hmh@hmh.eng.br, hpa@zytor.com,
       jbarnes@virtuousgeek.org, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       thellstrom@vmware.com, tj@kernel.org, venkatesh.pallipadi@intel.com,
       x86@kernel.org, yinghai@kernel.org
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/PFL7tc7ax6SUUNgFtX/zjj4XvYsEOulZhcAVgGD1+eypZl
 bwrmWL9oB8qqc8aj3TT06ipqc1VCn7a64jalJMG1eor/N18uO5d7C1XxxNu9
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> If we are going to make ioremap() and set_memory_wc() add mtrr's in
> non-pat case, then we need to delete the added mtrr(s) in the
> corresponding iounmap() and set_memory_wb() aswell.
> 
> hmm, this is becoming too complex. The way i915 and other graphics
> drivers are using set_memory_wc(), it is def a bad idea to start adding
> mtrr's behind the back for non-pat case.

Yes, maybe it's better to drop it for ioremap() and set_memory_wc(). But I'd like
to keep it for mmapping the PCI region. It should help all the people with
PAT-incapable CPUs and graphics chips without DRM support (for them there
simply is no driver that should set up the MTRR entries...).

> Can't we just force PAT option always and we probably don't care about
> ioremap_wc() on processors were PAT doesn't get enabled because of known
> errata.

I don't think this is a good idea, Robert Hancock wrote there may be millions of
such Laptops (Core Solo/Duo erratum AE7, Pentium M erratum Y31) :
  http://marc.info/?l=linux-kernel&m=125537136105246&w=2

> or Perhaps just try to add mtrr only for the pci mmap case like the 4th
> patch in this series..

I'd prefer this! ;-)

Kind regards,
  Thomas
