Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZJUOKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZJUOKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZJUOKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:10:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:4765 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZJUOKQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;11:1>);
	Wed, 21 Oct 2009 10:10:16 -0400
Message-Id: <4ADF32A0020000780001B20A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Oct 2009 15:11:12 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Schlichter" <thomas.schlichter@web.de>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, <x86@kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       <dri-devel@lists.sourceforge.net>, "Ingo Molnar" <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	 available
References: <1394846127@web.de>
In-Reply-To: <1394846127@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Schlichter <thomas.schlichter@web.de> 21.10.09 15:45 >>>
>Ingo Molnar wrote:
>> Can we eliminate mtrr_add_unaligned() as Suresh suggested, and still 
>> make it work on your testbox?
>
>Yes, I had that in the first place, but Jan suggested to extend it to also
>handle non-aligned, non-power-of-two cases:
>  http://marc.info/?l=linux-kernel&m=125541951529918&w=2 

I merely pointed out it wouldn't work for unaligned addresses or sizes
passed in.

>So if it's OK for Jan, I'll reduce the functionality again and use mtrr_add()
>instead. Btw. this simply means to drop mtrr_add_unaligned(), all the other
>parts are still required for reference counting and a proper mtrr_del() on file
>close.

I'm perfectly fine with just handling the aligned case, as long as the code
checks that the alignment constraints are met.

Jan

