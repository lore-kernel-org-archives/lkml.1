Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZC2Ok3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZC2Ok3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZC2OkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:40:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42637 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZC2OkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:40:20 -0400
Message-ID: <49CF87FB.4030608@redhat.com>
Date: Sun, 29 Mar 2009 10:38:51 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       frankeh@watson.ibm.com, akpm@osdl.org, nickpiggin@yahoo.com.au,
       hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<1238195024.8286.562.camel@nimitz>	<49CD69EB.6000000@redhat.com> <20090329162024.687196ab@skybase>
In-Reply-To: <20090329162024.687196ab@skybase>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Fri, 27 Mar 2009 20:06:03 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
>> Dave Hansen wrote:
>>> On Fri, 2009-03-27 at 16:09 +0100, Martin Schwidefsky wrote:
>>>> If the host picks one of the
>>>> pages the guest can recreate, the host can throw it away instead of writing
>>>> it to the paging device. Simple and elegant.
>>> Heh, simple and elegant for the hypervisor.  But I'm not sure I'm going
>>> to call *anything* that requires a new CPU instruction elegant. ;)
>> I am convinced that it could be done with a guest-writable
>> "bitmap", with 2 bits per page.  That would make this scheme
>> useful for KVM, too.
> 
> This was our initial approach before we came up with the milli-code
> instruction. The reason we did not use a bitmap was to prevent the
> guest to change the host state (4 guest states U/S/V/P and 3 host
> states r/p/z). With the full set of states you'd need 4 bits. And the
> hosts need to have a "master" copy of the host bits, one the guest
> cannot change, otherwise you get into trouble.

KVM already has the info from the host bits somewhere else,
which is needed to be able to actually find the physical
pages used by a guest.

That leaves just the guest states, so a compare-and-swap may
work for non-s390.

-- 
All rights reversed.
