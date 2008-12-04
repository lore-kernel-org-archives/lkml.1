Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYLDMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYLDMNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYLDMND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:13:03 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:31984 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYLDMNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:13:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i3saHRMbP0XocYbrGfTEWC3wjikWdqHwfScfzCy1XxtXpovD9HlPe4oY9tMOnZZddR
         dksHnC1Pz6uI/yp+L0i3cqadt2YQt4cEcqvx4nmKs7SL0pY81TGwyNrO0mh5PrDEKZoa
         3lwHvq+18cVxevkcu6FDx6nVzgVWF9/+w80Pg=
Message-ID: <e2e108260812040412j1f3f353bv2834750dbe914c48@mail.gmail.com>
Date: Thu, 4 Dec 2008 13:12:58 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: A question about sparse: how to use __acquires() and __releases() correctly ?
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>,
       "Alexander Shishkin" <alexander.shishckin@gmail.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>
In-Reply-To: <e2e108260812021159r31eb86a1v95d2cbdf7cfdae2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260812021159r31eb86a1v95d2cbdf7cfdae2d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ping]

Is there anyone who can help me with the question below ?

Thanks,

Bart.

On Tue, Dec 2, 2008 at 8:59 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> Hello,
>
> I'm helping to prepare the SCST source code for inclusion in the Linux
> kernel by a.o. cleaning up sparse warnings. Although most of the SCST
> source code has been annotated by this time it's still not clear to me
> how to use __acquires() and __releases() correctly.
>
> I will illustrate my questions via the following code from
> net/core/dev.c, Linux kernel version 2.6.27.7:
>
> void dev_seq_stop(struct seq_file *seq, void *v)
>        __releases(dev_base_lock)
> {
>        read_unlock(&dev_base_lock);
> }
>
> The command "make C=2 M=net/core" produces the following output for
> the above function (using a sparse binary built from the sparse git
> repository, last updated on August 26, 2008):
>
> net/core/dev.c:2579:2: warning: context problem in 'dev_seq_stop':
> '_read_unlock' expected different context
> net/core/dev.c:2579:2:    context 'lock': wanted >= 1, got 0
>
> My questions are as follows:
> * Which argument type should be passed to __releases() -- a pointer to
> a lock structure or the lock strucure itself ? In the header file
> include/linux/spinlock_api_smp.h a pointer is passed to __acquires()
> and __releases(), while other code (like the above) passes the lock
> structure itself to the __acquires() and __releases() annotations.
> * If the __releases() annotation is used correctly in net/core/dev.c,
> why does sparse complain about a context problem ?
>
> Please keep me in CC -- I'm not subscribed to the LKML.
>
> Bart.
>
