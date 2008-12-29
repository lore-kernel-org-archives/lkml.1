Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYL2R4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYL2R4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYL2R4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:56:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:33513 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751520AbYL2R4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:56:40 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX189J7QBrSc9ZzSUHpoILdyAnhEaFRu2650kdUszJ2
	5Ql25rROXTsKWV
Message-ID: <49590F58.9040909@gmx.de>
Date: Mon, 29 Dec 2008 18:56:40 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
CC: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, jmm@inutil.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 2/2] parisc: fix module loading failure of large modules
References: <20081229161446.C91EB4EDA@hiauly1.hia.nrc.ca>
In-Reply-To: <20081229161446.C91EB4EDA@hiauly1.hia.nrc.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John David Anglin wrote:
> Hi Helge,
> 
>> With this patch we now instead append individual PLT stub entries
>> directly at the end of the code sections where the stubs are actually
>> called. This reduces the distance between the PCREL location and the
>> stub entry so that the relocations can be fulfilled.
> 
> GCC for PA-RISC assumes that the stubs will be placed before the code
> section.  This is what HP-UX does.  It's also not possible to compute
> the distance to the end of a function in GCC due to the way branch
> shortening is done.  If the distance to the start of the code section
> is too large, GCC outputs a long call.

Interesting. I didn't knew that.

> If you can insert them before the code section where the stubs are
> called, this will minimize the chance that a pc-relative call will
> not reach its stub.

Yes, good idea.
I'll change that and send an updated patch.

> Great patch!

Thanks!

Helge
