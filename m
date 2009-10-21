Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZJUNpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZJUNpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 09:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZJUNpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 09:45:10 -0400
Received: from fmmailgate07.web.de ([217.72.192.248]:56054 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZJUNpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 09:45:09 -0400
Date: Wed, 21 Oct 2009 15:45:12 +0200
Message-Id: <1394846127@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+kjfHCRhu1AX2o54aE0LDaYF77abZcLpWljyBowLOVaXKL5
 IvPJwOELpR5SyiW52MG2f6Nk1y7Z6Wh2g+YFsrbipmzQWxC8d3WTJnkuZ6dp
 g==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> I think we can simplify this  by just using mtrr_add_page() and avoid
> all the complexity that comes with mtrr_add_unaligned().
> 
> pci_mmap_range() should call one mtrr_add_page() if the base and size
> are nicely aligned. Almost all the cases, this is the usage sequence
> here anyway.

Ingo Molnar wrote:
> Can we eliminate mtrr_add_unaligned() as Suresh suggested, and still 
> make it work on your testbox?

Yes, I had that in the first place, but Jan suggested to extend it to also
handle non-aligned, non-power-of-two cases:
  http://marc.info/?l=linux-kernel&m=125541951529918&w=2

So if it's OK for Jan, I'll reduce the functionality again and use mtrr_add()
instead. Btw. this simply means to drop mtrr_add_unaligned(), all the other
parts are still required for reference counting and a proper mtrr_del() on file
close.

Kind regards,
  Thomas
