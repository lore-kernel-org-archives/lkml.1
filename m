Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYIKX0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYIKX0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYIKX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:26:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32989 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYIKX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BsQWEH6n8nCe1IQ2BS8PxqgV94Fx1Rh9FRUtzmhp8yVgZYKnKZwXyTDs3qUp8SGUBt
         cltttAe6ft0mFma8mYEPPd1m8eLie7bNcgmZAQpPdj9QSk1H/M8pbhPT6KWv6+Z6Zogc
         Nxfse+fO5vZynJMSJSo0ISZckRVeFwIiRxCSE=
Message-ID: <48C9A8D3.60408@gmail.com>
Date: Fri, 12 Sep 2008 01:25:07 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local> <20080829211345.4355.89284.stgit@denkblock.local> <48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local> <48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local> <48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local> <48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local> <48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local> <48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local> <48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local> <48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local> <48C82CB1.2070308@gmail.com> <871vzrogpz.fsf@denkblock.local> <48C850AA.2030409@gmail.com> <87k5diq35g.fsf@denkblock.local> <48C91458.7090503@gmail.com>            <48C9168C.4090101@gmail.com> <25227.1221157727@turing-police.cc.vt.edu>
In-Reply-To: <25227.1221157727@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 11 Sep 2008 15:01:00 +0200, Tejun Heo said:
>> Ah.. just one more thing.
>>
>> I think it would be easier on the application if the written timeout
>> value is cropped if it's over the maximum instead of failing the
>> write.
> 
> Which is better, failing the write so the application *knows* there is a
> problem, or letting the application proceed with a totally incorrect idea of
> what the value is set to?

It depends.  As -EINVAL either results in program failure or no
protection for the event.

> For instance, what happens if the program tries to set 100, it's silently
> clamped to 10, and it then tries to set a timer for itself to '90% of the
> value'?  It might be in for an unpleasant surprise when it finds out that
> it's overshot by 81....

Hitting the limit would be a pretty rare occasion and which way we go
it's not gonna be too pretty.  e.g. Let's say a program calculates
timeout according to some algorithm which 99.9% of the time stays in
the limit but once in the blue moon hits the ceiling.  Given the
characteristics of the problem and very high limit value, I think it's
better to have cropped value.

How about returning -OVERFLOW while still setting the timeout to the
maximum?

Thanks.

-- 
tejun
