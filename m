Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989Ab0AGT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0AGT6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972Ab0AGT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:58:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34538 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0AGT6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sZ5kF1sWTqoV4bndti+x/CEFbp97dHwRCl41SgVwfM3YYf1fTaU4k/h78hqamUh0ef
         ZiO82aEpCAPAAgE3XOZAWtsnESp8iTRaqcGfwLw1+C5JJqGNQ7+T8ReAe7K++dqo6qqm
         bmae31N3xSr8lMHkZPebCi8wWVvUNnkGjDeRI=
MIME-Version: 1.0
In-Reply-To: <4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
References: <4B3B86CC.5010205@gmail.com> <4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Thu, 7 Jan 2010 20:58:10 +0100
Message-ID: <25e057c01001071158n1755ee99iae17522e269aa1ff@mail.gmail.com>
Subject: Re: [PATCH] mpt2sas: Fix &&/|| confusion in _scsih_sas_device_status_change_event()
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 8:31 PM, Moore, Eric <Eric.Moore@lsi.com> wrote:
> nack
>
> The code beyond this check is intended for either INTERNAL_DEVICE_RESET or CMP_DEVICE_RESET.   If the reason code is something else, we will want to return.  There are 10 other types of reason codes besides these two. This proposed patch means we return only when the reason code is either INTERNAL_DEVICE_RESET or CMP_INTERNAL_RESET.
>
> Eric Moore

my patch is correct but my changelog was wrong. Sorry for the
confusion. It should have been:

Even if the ReasonCode is not INTERNAL_DEVICE_RESET nor CMP_DEVICE_RESET
this still evaluates to true.

you can test this with:

#include <stdio.h>

int main()
{
        int d;
        for (d=0;d<4;++d)
                printf("!(%d == 1 && %d == 2) = %d\n", d, d, !(d == 1
&& d == 2));
        for (d=0;d<4;++d)
                printf("!(%d == 1 || %d == 2) = %d\n", d, d, !(d == 1
|| d == 2));
        return 0;
}

Roel
