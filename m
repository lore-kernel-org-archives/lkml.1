Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZERGcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZERGcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 02:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZERGb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 02:31:57 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:42021 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZERGb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 02:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c4ErhQdYj1lvcAcLj3ztNA1pWK4CU9WSgYi27Jx0GJg+ET/LiP+Mby2tojxgLvfisK
         Sk5TFzb5gz20jnfSAIH55g1FxoXmI4UoWbVdrNYV8qhsWZXexBPv32j2UNvLVTtebKDa
         HTWZDBPvampAViDlmazxi/RnTo3vwy88XhSPo=
MIME-Version: 1.0
In-Reply-To: <20090516163610.8a012268.akpm@linux-foundation.org>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
	 <385Pu-agh7M.A.SU.iYzDKB@chimera>
	 <20090516163610.8a012268.akpm@linux-foundation.org>
Date: Mon, 18 May 2009 09:31:47 +0300
X-Google-Sender-Auth: dfb76fd0ed075039
Message-ID: <84144f020905172331x6032394fn172f02e36298192d@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux-wireless@vger.kernel.org, adrian@newgolddream.dyndns.info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, 16 May 2009 21:20:45 +0200 (CEST) "Rafael J. Wysocki"
<rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13319
>> Subject               : Page allocation failures with b43 and p54usb
>> Submitter     : Larry Finger <Larry.Finger@lwfinger.net>
>> Date          : 2009-04-29 21:01 (18 days old)
>> References    : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>> Handled-By    : Johannes Berg <johannes@sipsolutions.net>

On Sun, May 17, 2009 at 2:36 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Well..  order-1 GFP_ATOMIC allocations are unreliable.  The networking
> code should hanlde the situation and recover.  I assume that is
> happening in this case?
>
> Perhaps we did something in that code after 2.6.29 which increased the
> frequency of the order-1 allocation attempts?  Maybe earlier kernels
> used order-0 all the time?  Those are much more reliable.

I wonder if this is related:

http://bugzilla.kernel.org/show_bug.cgi?id=13069

Both point to post 2.6.29... Hmm.
