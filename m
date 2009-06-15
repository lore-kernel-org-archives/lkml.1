Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbZFOI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbZFOI0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZFOI0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:26:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:1807 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZFOI0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kHqSlOwVvxmRCLIJax9BuO+oHmFCOLYDEAbAMO6I4xY1mMNhZhu0if9EzNB9bzGgI2
         EYqZ3GSwhQuuscjCjmjvOBZpOl3UrOG8OZqCtYsCMJc2gI0z9ek9Me4cm9vvGO4cXvUy
         7rQKVkQOHLV0zxL+yKbEkIEt5363iDVmCiVdg=
MIME-Version: 1.0
In-Reply-To: <4A36041C.9050202@jp.fujitsu.com>
References: <4A3601BF.2000201@jp.fujitsu.com> <4A36041C.9050202@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 16:26:08 +0800
Message-ID: <851fc09e0906150126x4bb003flbf099aff0eed2a66@mail.gmail.com>
Subject: Re: [PATCH 02/16] x86, mce: call-in should be after updating 
	global_nwo
From: huang ying <huang.ying.caritas@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> At the beginning of Monarch synchronization, processors wait until
> all of them have entered the exception handler and then check the
> global_nwo to determine if any of them saw a fatal event.
>
> However since current code does call-in before updating global_nwo,
> it might happen that the global_nwo does not reflect some of local
> nwo at the time.  This might break printing corrected errors not
> handled yet on panic.

This is almost same as the patch that I just posted. I think this is
because it trigger a failure in mce-test suite, and we both find the
failure.

But your patch lacks memory barrier between mce_callin and global_nwo
updating/reading. Atomic operations does not imply memory barrier.

Best Regards,
Huang Ying
