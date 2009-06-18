Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZFRIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZFRIgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZFRIgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:36:08 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:43234 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZFRIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:36:06 -0400
X-SourceIP: 213.93.53.227
Subject: Re: Accessing user memory from NMI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <19001.63708.989256.78908@cargo.ozlabs.ibm.com>
References: <19001.63708.989256.78908@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 10:36:09 +0200
Message-Id: <1245314169.13761.23121.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 18:20 +1000, Paul Mackerras wrote:
> What was the conclusion you guys came to about doing a user stack
> backtrace in an NMI handler?  Are you going to access user memory
> directly or are you going to use the __fast_get_user_pages approach?
> 
> Ben H and I were talking today about what we'd need in order to be
> able to read user memory in a PMU interrupt handler.  It looks like we
> could read user memory directly with a bit of care, on 64-bit at
> least.  Because of the MMU hash table that would almost always work
> provided the page has already been touched (which stack pages would
> have been), but there is a small chance that the access might fail
> even if the address has a valid PTE.  At that point we could fall back
> to the __fast_get_user_pages method, but I'm not sure it's worth it.

Currently we have the GUP based approach, but Ingo is thikning about
making the pagefault handler NMI safe on x86 for .32.



