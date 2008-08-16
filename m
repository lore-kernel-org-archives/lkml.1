Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYHPJBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYHPJBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 05:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYHPJBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 05:01:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:13498 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYHPJBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ra76/PZ6dSH0JQhCpYorioM1Gb+EZx5y6ArsUqnNv6ihQrN1GUngT/9apNkdwIjfGB
         AQIuOFEZLMLxsILSHOop6NKY3ZkyFzjG5o+m7UUCe/sJ+iTaTjTobNvf8SxyDiFyAaYB
         +3aLeWIvEBV5pSqA0y6cpTTbo86QqR7fyJAoI=
Message-ID: <86802c440808160200s3e1ede7bhf66a41b1944750d4@mail.gmail.com>
Date: Sat, 16 Aug 2008 02:00:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>
In-Reply-To: <m11w0p74s7.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <m11w0p74s7.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 1:17 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> The 28 bits aren't enough, are they: we need domain as well (and surely we can
>> have more than 16 domains?)
>
> The justification is questionable.  The fact that the irq number
> reported for msi-x vectors is only 16bits is a bug.  Everywhere else
> in the kernel an irq number is stored in a 32bit field.

they assume irq < 65536?

if use NR_IRQS = NR_VEVTORS * NR_CPUS...
256*1024 ==> .... PROBLEM...

>
> We also have a few other bits of craziness in the msix interface.
> The entry field in msix_entry is unnecessary.

Agreed. qla will have another copy again.

>
> In fact now that we have a linked list of irq entries we stop passing
> the structure entirely.

msi_list in dev?

YH
