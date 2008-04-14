Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbYDNSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbYDNSqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934292AbYDNSmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:44385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbYDNSmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kluygMUE/L4uRBUo4lLedmlKfBQ8tl4/qe6UvKit8nljyviQdcyYLgf3SkVMnBJfluCbBFrCkfmW/SsjAqzTFPVh08RqVUHmDs9giKVOuGbY0iqx/91gAlOVKOghngg/sybfAONaIp6GIxpTDMmGBD67vAOO/1Y0rXfpZkLXIuE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Does process need to have a kernel-side stack all the time?
Date: Mon, 14 Apr 2008 20:42:40 +0200
User-Agent: KMail/1.8.2
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200804141547.57719.vda.linux@googlemail.com> <87hce4uya8.fsf@basil.nowhere.org>
In-Reply-To: <87hce4uya8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804142042.40109.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 19:44, Andi Kleen wrote:
> > A lot of effort went into minimizing of stack usage.
> > If I understand it correctly, one of the reasons for this
> > was to be efficient and not have lots of pages
> > used for stacks when we have a lot of threads
> > (tens of thousands).
> 
> Actually the real reason the 4K stacks were introduced IIRC was that
> the VM is not very good at allocation of order > 0 pages and that only
> using order 0 and not order 1 in normal operation prevented some stalls.
> 
> This rationale also goes back to 2.4 (especially some of the early 2.4
> VMs were not very good) and the 2.6 VM is generally better and on
> x86-64 I don't see much evidence that these stalls are a big problem
> (but then x86-64 also has more lowmem).
> 
> Note that your proposal doesn't change this at all.

Actually, it does, because if you have only N*no_of_CPUs stacks,
you can allocate them upfront, making fragmentation a non-issue.

However, the proposal doesn't look viable anyway.
--
vda
