Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZGNWzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZGNWzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbZGNWzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:55:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:53625 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZGNWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:55:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Odgin/n6AhKDx4kItpGgtvBMM2Jy2HEiXps2u3ay4m1YfUfmFBIFjRWfkPcmQICbH
	8yHV+AG8wNqmjMALgLWRA==
MIME-Version: 1.0
In-Reply-To: <1247608169.13426.16602.camel@nimitz>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
	 <1247596470.13426.16088.camel@nimitz>
	 <2f86c2480907141426r16f8ccf3o9770e25cc8d2e509@mail.gmail.com>
	 <1247608169.13426.16602.camel@nimitz>
Date: Tue, 14 Jul 2009 15:55:16 -0700
Message-ID: <2f86c2480907141555o761992bal8f48b2861a515b69@mail.gmail.com>
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Benjamin Blum <bblum@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 2:49 PM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
> On Tue, 2009-07-14 at 14:26 -0700, Benjamin Blum wrote:
>> This method looks to be a compromise between Andrew's proposed
>> generalized solution ( http://lkml.org/lkml/2009/7/2/518 ) and the
>> current quick-fix. The problem with it is that it'll require a layer
>> between whoever's using the array and managing the list structs (for
>> the case where we need to chain multiple blocks together), and if
>> we're going to put forth enough effort for that, we may as well go
>> ahead and write up a generalized kernel-wide library to fix this size
>> problem globally.
>
> This "Andrew" guy seems to know what he's talking about. :)

Imagine that.

> We've also got a set of pgarrs (struct page arrays) in the
> checkpoint/restart code that would make use of something generic like
> this.

Indeed. Once we get a generic dynamic array library, this and wherever
else in the kernel can be rearranged to use it.
