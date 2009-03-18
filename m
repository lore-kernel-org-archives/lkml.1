Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZCRXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZCRXhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 19:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZCRXhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 19:37:32 -0400
Received: from gw.goop.org ([64.81.55.164]:44908 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZCRXhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 19:37:31 -0400
Message-ID: <49C185B4.90004@goop.org>
Date: Wed, 18 Mar 2009 16:37:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Shentino <shentino@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com>	 <49C1665A.4080707@goop.org> <49C16A48.4090303@redhat.com>	 <49C17230.20109@goop.org> <49C17880.7080109@redhat.com>	 <49C17BD8.6050609@goop.org> <49C17E22.9040807@redhat.com> <70513aa50903181617r418ec23s744544dccfd812e8@mail.gmail.com>
In-Reply-To: <70513aa50903181617r418ec23s744544dccfd812e8@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shentino wrote:
> But, does a CPU running a task in userspace effectively have a read 
> lock on the page tables?

No.  A process has its own user pagetable which the kernel maintains on 
its behalf.  The kernel will briefly take locks on it while doing 
modifications, mostly to deal with multithreaded usermode code running 
on multiple cpus.

    J
