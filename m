Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779Ab0AEPF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0AEPF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683Ab0AEPFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:05:54 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:53452 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0AEPFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lkktW49N7QSPElyx0iGcI2qQBUqzypZrE0ZiLs3kxgB2rs4RmaNvM5dqH1vCO+/Zvj
         blYXxlBZXgyjhTLKHD1tbflxrwwJr3LYjx07Sg2PL2qrxkHTB430D+WRW8so4P4kqPzn
         2obfUojrUL0nkj3D5QCUJLeCmsiCgDVGwMUPw=
MIME-Version: 1.0
In-Reply-To: <1262700774-1808-1-git-send-email-gleb@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
From: Jun Koi <junkoi2004@gmail.com>
Date: Wed, 6 Jan 2010 00:05:32 +0900
Message-ID: <fdaac4d51001050705s3f46dd0fi948a3b3ea803fa51@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV 
	guest
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 11:12 PM, Gleb Natapov <gleb@redhat.com> wrote:
> KVM virtualizes guest memory by means of shadow pages or HW assistance
> like NPT/EPT. Not all memory used by a guest is mapped into the guest
> address space or even present in a host memory at any given time.
> When vcpu tries to access memory page that is not mapped into the guest
> address space KVM is notified about it. KVM maps the page into the guest
> address space and resumes vcpu execution. If the page is swapped out
> from host memory vcpu execution is suspended till the page is not swapped
> into the memory again. This is inefficient since vcpu can do other work
> (run other task or serve interrupts) while page gets swapped in.
>
> To overcome this inefficiency this patch series implements "asynchronous
> page fault" for paravirtualized KVM guests. If a page that vcpu is
> trying to access is swapped out KVM sends an async PF to the vcpu
> and continues vcpu execution. Requested page is swapped in by another
> thread in parallel.  When vcpu gets async PF it puts faulted task to
> sleep until "wake up" interrupt is delivered. When the page is brought
> to the host memory KVM sends "wake up" interrupt and the guest's task
> resumes execution.
>

Is it true that to make this work, we will need a (PV) kernel driver
for each guest OS (Windows, Linux, ...)?

Thanks,
Jun
