Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZFVUwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZFVUwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFVUwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:52:02 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33884 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZFVUwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:52:01 -0400
MIME-Version: 1.0
Message-ID: <90774647-7bf6-4d54-bd39-e7ff74d055ab@default>
Date: Mon, 22 Jun 2009 13:50:36 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <4A3F95A6.5040503@nortel.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A3FEEA1.0024:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > What if there was a class of memory that is of unknown
> > and dynamically variable size, is addressable only indirectly
> > by the kernel, can be configured either as persistent or
> > as "ephemeral" (meaning it will be around for awhile, but
> > might disappear without warning), and is still fast enough
> > to be synchronously accessible?
> > 
> > We call this latter class "transcendent memory"
> 
> While true that this memory is "exceeding usual limits", the more
> important criteria is that it may disappear.
> 
> It might be clearer to just call it "ephemeral memory".

Ephemeral tmem (precache) may be the most interesting, but there
is persistent tmem (preswap) as well.  Both are working today
and both are included in the patches I posted.

Looking for a term encompassing both, I chose "transcendent".

> There is going to be some overhead due to the extra copying, and at
> times there could be two copies of data in memory.  It seems possible
> that certain apps right a the borderline could end up running slower
> because they can't fit in the regular+ephemeral memory due to the
> duplication, while the same amount of memory used normally could have
> been sufficient.

This is likely true, but I expect the duplicates to be few
and transient and a very small fraction of the total memory cost for
virtualization (and similar abstraction technologies).

> I suspect trying to optimize management of this could be difficult.

True.  Optimizing the management of ANY resource across many
consumers is difficult.  But wasting the resource because its
a pain to optimize doesn't seem to be a good answer either.

Thanks!
Dan
