Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZA0ERf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZA0ERf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 23:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZA0ER1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 23:17:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:16553 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZA0ER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 23:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xH7wGU7ArS95wmsgAkHzyqqTMtbxZZKAnSTrt7zXGCP4VoDxvt7vKZTW8jTobAVb8B
         eXkfkCx7t9wRfWbzYqiSHWZnVNrIPkkzlcL1mNzOtWG5ctuVHHZM021Oh1ZHlKsC30ZM
         /pTM+IsS8NBSizvE6y8eRxYOQwAbiveU2xD4U=
Message-ID: <497E8AD4.7030702@gmail.com>
Date: Tue, 27 Jan 2009 13:17:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unified percpu stuff
References: <497E5F76.10301@goop.org>
In-Reply-To: <497E5F76.10301@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeremy Fitzhardinge wrote:
> I'm really pleased to see the unified percpu stuff in the kernel, but
> unfortunately its breaking Xen at the moment.
> It looks like this is just a matter of initializing %gs properly in
> xen_start_kernel.  Is there any problem with me doing a load_gs_base(0)
> somewhere early in xen_start_kernel (arch/x86/xen/enlighten.c)?

No, not at all.  Patches welcome.  :-)

> Is the initial percpu are and offset for cpu0 all set up?  Do I need
> to make it #ifdef CONFIG_SMP?
>
> Do I need to do anything for 32-bit? (I haven't tested that yet.)

The current tj-percpu[1] contains Brian's commit which consolidates
load_gs_base() into switch_to_new_gdt(), so you'll either need to call
it instead or call wrmsrl() or loadsegment() directly if that doesn't
fit the bill (but I think it will).

The initial offset is different between 32 and 64.  Please take a look
at BOOT_PERCPU_OFFSET definition in setup_percpu.c.

Thanks.

-- 
tejun

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
