Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXISQPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXISQPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbXISQPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:15:32 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:28686
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757331AbXISQPb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:15:31 -0400
Message-Id: <46F16779.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 19 Sep 2007 17:16:25 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386/PAE: avoid temporarily inconsistent pte-s
References: <46F150CB.76E4.0078.0@novell.com>
 <200709191809.47351.ak@suse.de>
In-Reply-To: <200709191809.47351.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 19.09.07 18:09 >>>
>On Wednesday 19 September 2007 16:39:39 Jan Beulich wrote:
>> One more of these issues (which were considered fixed a few releases
>> back): Other than on x86-64, i386 allows set_fixmap() to replace
>> already present mappings. Consequently, on PAE, care must be taken to
>> not update the high half of a pte while the low half is still holding
>> the old value.
>
>Hmm perhaps it would be better to just forbid it on i386 too.
>Do you know who uses it?

PCI's mmconfig accessor. One could of course make it call clear_fixmap() prior
to establishing a new mapping, but I thought that was not intended and is the
reason for allowing this.

Jan

