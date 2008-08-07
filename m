Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYHGMhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYHGMhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYHGMgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:36:54 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:52043 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbYHGMgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:36:53 -0400
Message-ID: <86802c440808070351m6400b290jb826d10407c7de77@mail.gmail.com>
Date: Thu, 7 Aug 2008 03:51:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080807111216.6cfdbeea@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1hc9yjb7x.fsf@frodo.ebiederm.org>
	 <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	 <m1y739j2z8.fsf@frodo.ebiederm.org>
	 <20080807002638.04699eac@lxorguk.ukuu.org.uk>
	 <m18wv9iqn9.fsf@frodo.ebiederm.org>
	 <20080807111216.6cfdbeea@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 3:12 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 06 Aug 2008 18:02:18 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>>
>> > A lot of these are range checks so could be replaced by a single
>> > valid_irq(irq) test.
>>
>> Yes.  My first impression was that with NR_IRQS dead valid_irq could
>> easily become. #define valid_irq(irq) ((irq) != 0)
>
> Not really - there are lots of cases where we sanity check an IRQ passed
> from user space or module parameter configuration. So we do actually need
>
>        valid_irq(irq)          ((irq) > 0 && (irq) < nr_irqs)
>
> [or relevant per arch alternatives]

#ifndef CONFIG_HAVE_SPARSE_IRQ
#define   valid_irq(irq)          ((irq) > 0 && (irq) < nr_irqs)
#else
#define   valid_irq(irq)          ((irq) > 0)

anyway why 0 is invalid instead of -1U...?

YH


#endif
