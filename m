Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYHHQSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYHHQSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYHHQR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:17:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYHHQRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:17:55 -0400
Message-ID: <489C70C2.1070708@kernel.org>
Date: Fri, 08 Aug 2008 09:13:54 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org> <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org> <489B8EF4.1030105@goop.org> <489B8FAD.4090904@kernel.org> <489BE351.5030206@goop.org>
In-Reply-To: <489BE351.5030206@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> No, but it's hardly vast effort, either.
> 
> Thinking about it, the fixmap really has to be as high as possible.  If 
> it were any lower, then it would either truncate the 1:1 mapping, or 
> shadow some physical memory.
> 

The proposal was to put it *before* the 1:1 mapping:

FIX_HOLE would start at TASK_SIZE
PAGE_OFFSET would shift to TASK_SIZE + PMD_PAGE_SIZE

All the remaining offsets remain as-is.

It's slightly less efficient than the current version, since we can't 
share the PDE page for the fixmap with the final vmalloc map, but not 
terribly so.

	-hpa
