Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYKZNit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYKZNit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKZNik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:38:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:3819 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYKZNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=DH2ys+P9IOcjhG4pKVBLpMFr80bLSeCMUVRhteTxrxRasV4yZ8yCRoG/eSsdq/l1XJ
         3Me7nbHIVbL+FptvdAjkYyC7lSg6KuqtSd8AOsT4qcUviApjKbTzlMM5BsWw8O44uXOV
         AZqntIxSedEcuB97sEKfWs4IkfaJV9Odfdt38=
Message-ID: <7c86c4470811260538s351899d3x31c3df1ad994add7@mail.gmail.com>
Date: Wed, 26 Nov 2008 14:38:37 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch 00/24] perfmon: introduction
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <18733.8024.91224.512595@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
	 <18733.8024.91224.512595@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On Wed, Nov 26, 2008 at 11:05 AM, Paul Mackerras <paulus@samba.org> wrote:
> eranian@googlemail.com writes:
>
>> This new version, named perfmon3, uses only 5 system calls (instead of 12).
>> Each call was carefully designed to allow for future extensions.
>
> I notice that the userspace stuff in CVS assumes perfmon3 has 7 system
> calls, the 5 added here plus pfm_create_sets and pfm_getinfo_sets.
> Are you planning to add those two later (in which case we should
> reserve the numbers now), or are you going to implement the
> functionality of those two in pfm_write and pfm_read?
>

Yes, the LKML patchset represents the very minimal functionality of perfmon3.
Libpfm/pfmon are coded to support the fully-featured version to help
with testing
and evaluations.

The 2 systems calls you are referring to go with event set and multiplexing, an
advanced feature which I intend to submit to LKML later. That's why I
did not add
those two calls immediately. People would have argued that the calls are
not used.

Furthermore, there is still some discussions as to how best to add the
set functionality
to the syscall API. We need to be able to:
    - create new sets
    - retrieve runtime execution about sets, e.g., number of
activations, timeout left
    - and possibility delete sets

I don't think we can reserve syscall numbers in advance. OTOH, the
perfmon3 syscalls
don't necessarily need to be contiguous, unless people tell me this is
a rule used by
the kernel developers.
