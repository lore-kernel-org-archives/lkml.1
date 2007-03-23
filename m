Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXCWGOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXCWGOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbXCWGOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:14:01 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:34047 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbXCWGOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:14:00 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc4-mm1
Date: Fri, 23 Mar 2007 17:18:20 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602B7D3.4030108@shadowen.org> <4602C83B.20608@shadowen.org>
In-Reply-To: <4602C83B.20608@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231718.20647.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
> Ok, I have yet a third x86_64 machine is is blowing up with the latest
> 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix levels
> so I have just fired off a set of tests across the affected machines on
> that latest hotfix stack plus the RSDL backout and the results should be
> in in the next hour or two.
>
> I think there is a strong correlation between RSDL and these hangs.  Any
> suggestions as to the next step.

Found a nasty in requeue_task
+	if (list_empty(old_array->queue + old_prio))
+		__clear_bit(old_prio, p->array->prio_bitmap);

see anything wrong there? I do :P

I'll queue that up with the other changes pending and hopefully that will fix 
your bug.

-- 
-ck
