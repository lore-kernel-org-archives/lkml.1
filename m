Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZJUOiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZJUOiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZJUOiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:38:07 -0400
Received: from fmmailgate07.web.de ([217.72.192.248]:33876 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZJUOiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:38:03 -0400
Date: Wed, 21 Oct 2009 16:38:06 +0200
Message-Id: <1394923769@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Jan Beulich <JBeulich@novell.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, dri-devel@lists.sourceforge.net,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not__available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18/TnW5KhxcrsXi2FQH1R9dwb6v/hY2yGOGNCPspnIYDvOI5
 VlKYfh3zpyWrf0M4LdztzhyvbhGapL2oHidtAQLSP/fl9CDs3K00bZVoT6oN
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> >Yes, I had that in the first place, but Jan suggested to extend it to also
> >handle non-aligned, non-power-of-two cases:
> >  http://marc.info/?l=linux-kernel&m=125541951529918&w=2 
> 
> I merely pointed out it wouldn't work for unaligned addresses or sizes
> passed in.

Oh, I'm sorry, I must have misinterpreted it...

> >So if it's OK for Jan, I'll reduce the functionality again and use mtrr_add()
> >instead. Btw. this simply means to drop mtrr_add_unaligned(), all the other
> >parts are still required for reference counting and a proper mtrr_del() on file
> >close.
> 
> I'm perfectly fine with just handling the aligned case, as long as the code
> checks that the alignment constraints are met.

Hmm, as far as I see mtrr_add() and mtrr_add_page() already check these
constraints. Do you want me to check them additionally? Or do you want to
completely fail the mmap() if these constraints are violated?

I'd let mmap() succeed even if the mtrr_add() fails...

Regards,
  Thomas
