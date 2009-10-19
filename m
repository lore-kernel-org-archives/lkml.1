Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZJSPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZJSPHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZJSPHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:07:36 -0400
Received: from fmmailgate06.web.de ([217.72.192.247]:34938 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZJSPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:07:36 -0400
Date: Mon, 19 Oct 2009 17:07:40 +0200
Message-Id: <1392918824@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+WftxQp2O3ire+UDV6zzSEG3NHYFCU63kRZoWwR2ScwR1kY
 Q6KH1TJ2V7p+NhQDMBtgpZFCwt4K41v3OiIowXAA9Oti6Qz7aTsJBXZBXQVs
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> I am not familiar with libpciaccess, but I was wondering why that library
> cannot realize it failed in its endeavour and use other means to accomplish
> its goals?

The thing is that the mmap() will succeed! Only the memory region will not be
set up as write combining when PAT is disabled. So userspace would have to
find out it PAT is enabled in kernel and accordingly set up MTRR entries. And
currently I don't know of a kernel interface that would tell userspace if PAT is
enabled.

Kind regards,
  Thomas
