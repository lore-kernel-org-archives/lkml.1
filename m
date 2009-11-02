Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZKBPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZKBPNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZKBPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:13:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZKBPNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:13:17 -0500
Date: Mon, 2 Nov 2009 17:13:20 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] Add "wait for page" hypercall.
Message-ID: <20091102151320.GC27911@redhat.com>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
 <1257076590-29559-9-git-send-email-gleb@redhat.com>
 <4AEED907.5030306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEED907.5030306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:05:11PM +0200, Avi Kivity wrote:
> On 11/01/2009 01:56 PM, Gleb Natapov wrote:
> >We want to be able to inject async pagefault into guest event if a guest
> >is not executing userspace code. But in this case guest may receive
> >async page fault in non-sleepable context. In this case it will be
> >able to make "wait for page" hypercall vcpu will be put to sleep until
> >page is swapped in and guest can continue without reschedule.
> 
> What's wrong with just 'hlt' and checking in the guest?
> 
Halting here will leave vcpu with interrupt disabled and this will prevent
"wake up" signal delivery. Enabling interrupts is also not an options
since we can't be sure that vcpu can process interrupt at this point.
And we can't allow NMI delivery for the same reason.

--
			Gleb.
