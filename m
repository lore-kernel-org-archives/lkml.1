Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbXE3VUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbXE3VUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXE3VTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:19:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42265 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbXE3VTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aGGkDcpiP+mnN6XNsEh6rwR41NfoG/Gm3QoYahfuaj0c1mTlMr3koqAYQBzJoubahtqC/mywkk74Sjhr0EN5Y0QtnXtYkWtL20FJ2u2hJKwert/otIxZZvy9JqoUM/WZQQtYjV3SCg9e3rfgAgcgyK6UkKhuEMtmXF7TZTDhp5c=
Message-ID: <86802c440705301419g2ed59773vda15c3d2a9e90479@mail.gmail.com>
Date: Wed, 30 May 2007 14:19:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: kexec and aacraid broken
Cc: vgoyal@in.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530141723.GB3773@in.ibm.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Vivek Goyal [mailto:vgoyal@in.ibm.com] writes:
> > So most likely if we start disabling the interrupts
> > in .shutdown routine we might skip resetting adapter
> > on every kexec without any side affects?
>
> Not that simple. The .shutdown would need to perform more resource
> cleanups of the .remove call to prevent side effects. I need to move
> some of the .remove activity into the .shutdown handler to make sure the
> adapter is quiesced.
>
> I will hold off on submitting any of these changes until they are
> evaluated and tested; I am waiting for feedback from Yinghai on the
> other mitigations that I feel are closer to the root cause.
>
1. [SCSI] aacraid: superfluous adapter reset for IBM 8 series
ServeRAID controllers
2. [SCSI] aacraid: kexec fix (reset interrupt handler)
3. aacraid_commit_reset.patch
4. [PATCH] aacraid: fix shutdown handler to also disable interrupts

the kernel with this patch -4  and even without 1, 2, 3

can load other kernel with or without patch 1,2,3

YH
