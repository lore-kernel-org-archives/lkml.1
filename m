Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZJSNpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZJSNpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZJSNpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:45:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:42421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbZJSNpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:45:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,585,1249282800"; 
   d="scan'208";a="505038271"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4ADC4A76020000780001AA49@vpn.id2.novell.com>
References: <4AD449A702000078000197EE@vpn.id2.novell.com>
	 <200910142114.12433.thomas.schlichter@web.de>
	 <4AD6EFD7020000780001A067@vpn.id2.novell.com>
	 <200910172148.36267.thomas.schlichter@web.de>
	 <4ADC4A76020000780001AA49@vpn.id2.novell.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 19 Oct 2009 06:44:34 -0700
Message-Id: <1255959874.2823.46.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 02:16 -0700, Jan Beulich wrote:
> Functionality-wise this looks fine to me

If we are going to make ioremap() and set_memory_wc() add mtrr's in
non-pat case, then we need to delete the added mtrr(s) in the
corresponding iounmap() and set_memory_wb() aswell.

hmm, this is becoming too complex. The way i915 and other graphics
drivers are using set_memory_wc(), it is def a bad idea to start adding
mtrr's behind the back for non-pat case.

Can't we just force PAT option always and we probably don't care about
ioremap_wc() on processors were PAT doesn't get enabled because of known
errata.

or Perhaps just try to add mtrr only for the pci mmap case like the 4th
patch in this series..

thanks,
suresh

