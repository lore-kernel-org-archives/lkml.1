Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZEEOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZEEOLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZEEOLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:11:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:23959 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEEOLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xebYtoU34cIIZDHRTXKOg2WsDhtrlTKCtLXGJ+HXCkmNRt4DVTuPwZCLHZmlOCI7yi
         1AefcsFnx0SsywvySrIqfqaSZVYjFkVhYStnl1gVsBp4e3SlgelDY0zKApF3xDs2bKDZ
         HZ9zf8zOnpVNPPU4FMR+kgGBMxQ16WzMQCMAQ=
MIME-Version: 1.0
In-Reply-To: <20090504235405.647772ed.akpm@linux-foundation.org>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <20090504235405.647772ed.akpm@linux-foundation.org>
Date: Tue, 5 May 2009 18:11:31 +0400
Message-ID: <acd2a5930905050711j57cbf81du2fe4dbb4e408e877@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] PM: suspend_device_irqs(): don't disable 
	wakeup IRQs
From: Vitaly Wool <vitalywool@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 10:54 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>
>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>> should not be disabled for suspend.
>>
>
> Why not?

Sounds like an interesting problem. If a wakeup depends on the
interrupt line, then no they definitely should not be disabled, as no
wakeup would happen otherwise. OTOH, this is not necessarily the case;
some SoCs configure wakeup sources as GPIOs (i.MXs do AFAIR) so it's
not clear if we should change generic source code in this case.

Vitaly
