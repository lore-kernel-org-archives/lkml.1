Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYG2WVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYG2WVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYG2WVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:21:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:8123 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYG2WVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=updQEbYIhexusrJvMJ/U3Bw4qb4Oc5N+Pt18IcFf1bFi7bIAXo8b2AUrrDbK85Kp34
         llu/zgIF/+OLU9bhgMteyLaFvS8pEqja7TDj+T98+be2+GSvXhc2nW8lYg7+1aq9vtD8
         WHv1Hnkhast4pdcq9EeE5oArRj2DaeqnMS/qg=
Message-ID: <86802c440807291521k6e6277b5ta05b180d0d1c963a@mail.gmail.com>
Date: Tue, 29 Jul 2008 15:21:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, "Jack Steiner" <steiner@sgi.com>,
       "Alan Mayer" <ajm@sgi.com>, "Cliff Wickman" <cpw@sgi.com>
In-Reply-To: <488F96DD.6020505@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	 <86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	 <86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	 <m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 3:17 PM, Mike Travis <travis@sgi.com> wrote:
> Eric W. Biederman wrote:
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>> On Tue, Jul 29, 2008 at 11:35 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>> On Tue, Jul 29, 2008 at 9:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>
>>> wrote:
>>>>> Hi Ingo, Thomas,
>>>>>
>>>>> Hit this on 2.6.27-rc1
>>>>>
>>>>> (The kernel bug is at line 356 (Its 357 as I applied a debug patch to
>>>>> print out the irq) (Full dmesg and .config attached)
>>>> can you boot with "debug apic=verbose pci=routeirq"?
>>> please try attached patch
>
> I didn't follow this from the start but one reason why NR_IRQS based on
> NR_CPUS is a bad idea, is the huge (nearly 300Mb) increase in memory usage
> (that's mostly wasted.)  I believe there's another patch coming real soon
> now to make irq allocations dynamic.  (I had also hoped to look closer at
> your irq abstraction patch you sent a while back.  Does that also address
> this issue?)

Yes.

>
> But this would be a show stopper for SGI being able to ship systems if the
> distros do not want to waste this much memory and won't set NR_CPUS=4096.

wonder if nr_irqs need to be probed dynamically too.

YH
