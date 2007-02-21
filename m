Return-Path: <linux-kernel-owner+w=401wt.eu-S1423189AbXBUWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423189AbXBUWRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423190AbXBUWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:17:15 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:42534 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423189AbXBUWRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:17:13 -0500
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Wed, 21 Feb 2007 22:16:15 +0000
Subject: Re: [patch 17/24] Xen-paravirt_ops: avoid having a bad selector
 in %gs during context switch
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Andi Kleen <ak@suse.de>, <virtualization@lists.osdl.org>
CC: Chris Wright <chrisw@sous-sol.org>, <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Message-ID: <C202752F.26C4%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [patch 17/24] Xen-paravirt_ops: avoid having a bad selector
 in %gs during context switch
Thread-Index: AcdWBebHJZ96rMH5EduN6gAWy6hiGQ==
In-Reply-To: <200702212310.02218.ak@suse.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/2/07 22:10, "Andi Kleen" <ak@suse.de> wrote:

>> /*
>> +  * Temporary hack: zero gs now that we've saved it so that Xen
>> +  * doesn't try to reload the old value after changing the GDT
>> +  * during the context switch.  This can go away once Xen has
>> +  * been taught to only reload %gs when it absolutely must.
>> +  */
>> + loadsegment(gs, 0);
> 
> Sorry, but i don't really want that unconditionally in the context switch.
> Adding a paravirt ops for it would be also ugly. Can Xen be fixed?

This is not an issue for correctness so this can safely be removed and still
work with current Xen.

 -- Keir


