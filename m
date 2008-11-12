Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYKLSCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYKLSCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYKLSCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:02:42 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:56115 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYKLSCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:02:41 -0500
Message-ID: <491B1A40.5020900@ct.jp.nec.com>
Date: Wed, 12 Nov 2008 10:02:40 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
References: <491A48E9.8020909@ct.jp.nec.com>	<491A496B.5010505@ct.jp.nec.com>	<20081112112937.GA6372@elte.hu> <18714.52512.213371.33245@harpo.it.uu.se> <491B0E6F.2010301@zytor.com>
In-Reply-To: <491B0E6F.2010301@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mikael Pettersson wrote:
>> It does cause each signal delivery to leak 2 uninitialised
>> kernel bytes to the end of retcode[], which seems unnecessary.
> 
> Not just unnecessary, it is a huge no-no for security.

Am I missing important thing?
The frame->retcode is 8 bytes and packed structure with padding
is 10 bytes each, and the code is copied to user stack 8 bytes only.

err |= __copy_to_user(frame->retcode, &code, 8);

I don't think the behavior is changed.

thanks,
Hiroshi Shimamoto

> 
> NAK on this.
> 
> 	-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

