Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZGUVsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZGUVsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZGUVsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:48:08 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:42245 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZGUVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F0/PUrUNfHxebn1xp2hGqYOMRMeG5yqmAmcdobk8k7UD2bCJ0bwEG6tn7wsM+mI0on
         LhTOolY8rjcc9cdWCsYSvzWW2RhGuUZJj64I0kl9EtlqMKSCaPprE4KrrkMxsWr6b6LL
         zeeLcPa4O1/bEg7m8L5owPRTFZ94XHV5huJ4k=
MIME-Version: 1.0
In-Reply-To: <20090721080612.GC10168@dtor-d630.eng.vmware.com>
References: <20090721080612.GC10168@dtor-d630.eng.vmware.com>
Date: Tue, 21 Jul 2009 22:48:05 +0100
Message-ID: <9b2b86520907211448t24a091e2i6d8ad89f709f35ff@mail.gmail.com>
Subject: Re: [RFC/RFT] serio - switch to using dev_pm_ops
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/input/serio/serio.c |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)

> -	if (!serio->suspended && state.event == PM_EVENT_SUSPEND)
> -		serio_cleanup(serio);
> -
> -	serio->suspended = state.event == PM_EVENT_SUSPEND ||
> -			   state.event == PM_EVENT_FREEZE;

> -	if (serio->suspended) {
> -		serio->suspended = false;
> -		serio_queue_event(serio, NULL, SERIO_RECONNECT_PORT);
> -	}

It looks like you should be able to remove the suspended field of
struct serio.  Or is it used somewhere else?

Regards
Alan
