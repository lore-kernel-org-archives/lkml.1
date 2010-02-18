Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab0BRK6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:58:09 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64763 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0BRK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cCFh8btSt0Nm3ZN9ENctu3cmSfmp72sz7NAHW13rrlj3IXqh7BUgHtXDFq4idgfEd8
         447o3AEDX4SBaLGLmQ9oVlM2FIpirJ184k+dMkOFWFmCW+o7itDc/oyrzsFn8dP3ec4/
         7jFgfXHNtdwZwqm7Mo+CGire2VVAGaiE8rrik=
MIME-Version: 1.0
In-Reply-To: <1266488746.26719.120.camel@laptop>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-9-git-send-email-luca@luca-barbieri.com>
	 <1266488746.26719.120.camel@laptop>
Date: Thu, 18 Feb 2010 11:58:01 +0100
X-Google-Sender-Auth: 762fab7e9b9d5c04
Message-ID: <ff13bc9a1002180258h667a96b2s611140fc3e2492be@mail.gmail.com>
Subject: Re: [PATCH 08/10] x86-32: support atomic64_t on 386/486 UP/SMP
From: Luca Barbieri <luca@luca-barbieri.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IIRC we dropped <i586 SMP support, and since we don't have a PMU on
> those chips atomic64_t doesn't need to be NMI safe, so a simple
> UP-IRQ-disable implementation should suffice.

We need the generic version with spinlocks for other architectures,
and reusing it is the cheapest way to support 386/486.

We thus get 386/486 SMP for free, and on UP the spinlocks simplify to
just IRQ disabling.

The only thing we could do is to #ifdef out the hashed spinlock array
in the generic implementation on UP builds, which would save about 1KB
of memory.
That is independent from this patch though.
