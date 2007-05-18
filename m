Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbXERS2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbXERS2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXERS21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:28:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:40084 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXERS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pruOHqZXCnsOsh1luAm1ChHpZWbKQrm79bI/vcWgjQOQUyYnxsi50WRCG8uyruUElWTCZCdt1ctCKPbxozEfgq0DM9n0FNS/+KiR5X48deg0tByJJNTJTy3ntjqxvEsWJMjHGpM5QsbEFUVuP5U1vJVH6QIRWr1WQ5Be58N7WJI=
Message-ID: <86802c440705181128t28652911w39d6de0c43d99a45@mail.gmail.com>
Date: Fri, 18 May 2007 11:28:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
In-Reply-To: <20070518180749.GA26081@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070518010119.GB12088@linux-os.sc.intel.com>
	 <m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
	 <20070518180749.GA26081@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
>
> If the vector number stays same during irq migration and if we reset remote
> IRR bit using the above method(edge and then back to level) during
> irq migration, then we have a problem. A new interrupt arriving on a new
> cpu will set the remote IRR bit and now the old inflight EOI broadcast
> reaches IOAPIC RTE(resetting the remote IRR bit, because the vector in the
> broadcast msg is same), while the kernel code still assumes that the remote
> IRR bit is still set. This will lead to more problems and issues.

coud add some line __assign_irq_vector. to make sure old_vector!=vector.

YH
