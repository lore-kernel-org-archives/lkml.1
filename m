Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827Ab0AFKTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0AFKTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798Ab0AFKTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:19:31 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53019 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0AFKT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:19:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lIxC6+NGBXJII7MB077Cd/zd0cUrHbjVh/IfT2him0Q+h8jN3ZGKGLzM81jV6zwPMb
         9gjm7yvqVF/1bG79O3e9zh9Y2315fmruFGwpgCaiSa9Eu0q8ax96grv8Sq8H+ydxX0aR
         MlEaR0coe2dXSOiHLNyEJzQn3CbMLaQCRNULA=
MIME-Version: 1.0
In-Reply-To: <4B43631A.2030101@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> 
	<fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com> 
	<4B43631A.2030101@redhat.com>
From: Jun Koi <junkoi2004@gmail.com>
Date: Wed, 6 Jan 2010 19:17:30 +0900
Message-ID: <fdaac4d51001060217h16ffb331mcc0db195630f4de4@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV 
	guest
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 1:04 AM, Avi Kivity <avi@redhat.com> wrote:
> On 01/05/2010 05:05 PM, Jun Koi wrote:
>>
>> Is it true that to make this work, we will need a (PV) kernel driver
>> for each guest OS (Windows, Linux, ...)?
>>
>>
>
> It's partially usable even without guest modifications; while servicing a
> host page fault we can still deliver interrupts to the guest (which might
> cause a context switch and thus further progress to be made).

Lets say, in the case the guest has no PV driver. When we find that a
guest page is swapped out, we can send a pagefault
to the guest to trick it to load that page in. And we dont need the
driver at all.

Is that a reasonable solution?

Thanks,
J
