Return-Path: <linux-kernel-owner+w=401wt.eu-S934730AbYGCHL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbYGCHL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYGCG6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:30805 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYGCFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LCKsVEBbHDzdKEkz1V2ksaJyOH1y2yyhE0rHzfdqH47sWpIvLUH36M01Dl5N+DKF3w
         iS+DLP/E2/p1Qg/m1bKm5cvp+829sXXtIOyfg1J7ehK+Y/9v8qG0xQD8lfuLXhIeJBFv
         rDx5SOpR6IxFtZkEjV0FCOcto/fo667D/RmdY=
Message-ID: <aec7e5c30807022211q3e06dbd9m143015cbf10cd81d@mail.gmail.com>
Date: Thu, 3 Jul 2008 14:11:22 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: User IRQ Mode
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20080702123158.2c4fefc6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	 <20080702121153.4d464885@lxorguk.ukuu.org.uk>
	 <20080702114224.GB6891@digi.com>
	 <20080702123158.2c4fefc6@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 8:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Note that the irq is disabled instead of acked.  So this should not be a
>> problem.  The userspace part then is responsible to ack (first) and
>> unmask the irq.
>
> That still doesn't make sense.
>
> If you call disable_irq in the IRQ handler you will deadlock because it
> waits until the IRQ handler has completed.

Right, the uio_userirq_handler() function should use
disable_irq_nosync() instead of disable_irq(). Otherwise we'll end up
waiting forever for IRQ_INPROGRESS to be cleared in synchronize_irq()
in the case of CONFIG_SMP.

Thanks!

/ magnus
