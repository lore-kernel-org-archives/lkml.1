Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYC0BV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYC0BV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbYC0BV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:21:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38470 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755193AbYC0BVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:21:25 -0400
Date: Wed, 26 Mar 2008 18:19:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: What if a TLB flush needed to sleep?
In-Reply-To: <alpine.LFD.1.00.0803262121440.3781@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.64.0803261817110.1115@schroedinger.engr.sgi.com>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
 <Pine.LNX.4.64.0803261222090.31000@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803262121440.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Thomas Gleixner wrote:

> Please use a mutex, not a semaphore. semaphores should only be used
> when you need a counting sempahore.

Seems that mutexes are mainly useful for 2 processor systems since they 
do not allow concurrent read sections. We want multiple processors able 
to reclaim pages within the same vma or file concurrently. This means 
processors need to be able to concurrently walk potentially long lists of 
vmas.
