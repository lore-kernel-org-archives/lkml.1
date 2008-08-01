Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYHADUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYHADUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYHADUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:20:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:23442 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYHADUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IlgRgrlAQK6jfntuR8huBDxxhDPqx7gK+qwsS60uvvZjOIIZBklXeWCBEMDspZ6cug
         MRkp0zpub701c+VfgCLee1LOwXpdYzKLaXdNCgiyU0PX3Z2AeUseLHj5VXk5NhMBxNoi
         B+z1jvcYWDU+I2Xa62GXF7JSOoEOv1+EKGD7k=
Message-ID: <86802c440807312020nb8ba0ddr6595139cfceb1b52@mail.gmail.com>
Date: Thu, 31 Jul 2008 20:20:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] serial: change remove NR_IRQS in 8250.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1iqum2rya.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807291414.55479.yhlu.kernel@gmail.com>
	 <200807302109.21519.yhlu.kernel@gmail.com>
	 <200807302110.10585.yhlu.kernel@gmail.com>
	 <200807310126.12572.yhlu.kernel@gmail.com>
	 <m1iqum2rya.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 4:50 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> replace
>>       [PATCH] serial: change irq_lists to use dyn_array
>> use small array with index to handle irq locking for serial port
>> hope 32 slot is enough
>
> Could you size this array by NR_UARTS (our worst case usage)

how about crazy user set that too big?

> and place irq_no in struct irq_info?
should be ok
>
> Also you want to hold irq_info->lock when you set or clear irq_no.
> Just to be on the safe side.  I expect we can avoid clearing the irq_no
> in the irq_lists and prevent a few more races from being a possibility.

will try

YH
