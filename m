Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYHCHwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYHCHwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYHCHw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:52:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:59679 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYHCHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kPeIGPRhyM+GBxF3EtExBVJLwxLMj2SS2ldTfKSoLBtOJMtBrI/qvumwnoI8EVfV0e
         M7VuW0mrjbD60RncskSuZptzrArjzHLiNHqM8Oewi6MOGKX+PK1abSjV44Fb1DEMHPFg
         0OPKL7TAj2ZnFLTj+QpV2W3yR9jC2cUBvINjI=
Message-ID: <82e4877d0808030052g4c345811u642667b2a8d87a1d@mail.gmail.com>
Date: Sun, 3 Aug 2008 03:52:24 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Rabin Vincent" <rabin@rab.in>
Subject: Re: gspca_zc3xx oops - 2.6.27-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Serge.A.S@tochka.ru, mxhaard@users.sourceforge.net, moinejf@free.fr,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com
In-Reply-To: <20080803073705.GA2754@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0808020922x64177318j6f8fe15955704521@mail.gmail.com>
	 <20080803073705.GA2754@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 3:37 AM, Rabin Vincent <rabin@rab.in> wrote:

>  2b:   0f b6 37                movzbl (%edi),%esi <---- offender
>  2e:   0f af f0                imul   %eax,%esi
>  31:   8d b6 00 00 00 00       lea    0x0(%esi),%esi
>  37:   0f b6 83 00 dc 15 f9    movzbl -0x6ea2400(%ebx),%eax
>
> %edi is Tgamma, and it is NULL because sd->gamma was 0, and the zeroth element
> of gamma_tb was loaded.

Yep - I arrived at the same conclusion and sent a patch few minutes
before I saw your mail.
I am clueless about V4L and gspca workings but I chose a different
approach to fix this -
http://marc.info/?l=linux-kernel&m=121774817612391&w=2 .

>
> Now sd->gamma shouldn't be zero because in sd_ctrls, the minimum value for it
> is set to 1.  This range should be checked by vidioc_s_ctrl in gspca.c, and we
> have this there:
>
>               if (ctrl->value < ctrls->qctrl.minimum
>                   && ctrl->value > ctrls->qctrl.maximum)
>                        return -ERANGE;
>

Sounds more appropriate but I am not sure how vidioc_s_ctrl leads to
the call trace in the OOPS - at least it doesn't show up there.


Thanks

Parag
