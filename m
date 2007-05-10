Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbXEJLyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbXEJLyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXEJLyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:54:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:4928 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443AbXEJLx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jt1Ykgu8PqMgXd84cIjbrD7Kc7PW/8F1gw9fyopLmy+CfQnU5IJ8cjSYcvbRgO2/6/uYLATowdVN8FFmv3HKyECtk7mjuMIPA/yD1cBI0rcGWtKp+iRct1bCmW1L62/6lTKyeWowLYF1aIDsaZJK+FziZBaVYHB2jd21uV02NpI=
Message-ID: <464307CC.40701@gmail.com>
Date: Thu, 10 May 2007 13:53:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: libata reset-seq merge broke sata_sil on sh
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com>
In-Reply-To: <464301D3.5060306@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some more thoughts.

Tejun Heo wrote:
> Hello,
> 
> Paul Mundt wrote:
> [--snip, thanks a lot for the detailed report--]
>> However, if I go back before any of the reset changes were introduced,
>> things were working fine, and there were no problems with waiting for
>> the reset. Ideas?
> 
> Hmm... It worked so well on all my sil's.  I'm a bit puzzled because we
> also failed the same condition before the change too.  The only change
> is we're less patient with the initial tries but in the end we give more
> than enough time to the device to prepare itself.
> 
> * Does your drive start spun down when it boots?  Can you post dmesg
> with printk timestamp turned on with kernel prior to reset-seq merge?
> 
> * In ata_bus_softreset() and sata_std_hardreset(), there's msleep(150)
> delay before checking the status post-reset.  Does increasing the delay
> make any difference?  Please try to increase it exponentially till it
> reaches 10sec.

* According to the report, things still work till 27c78b37 - commit for
the actual merge and there's no related change till the current master
from there.  So, which commit actually breaks detection?  Or is
detection just flaky after b8cffc6a?

* How does things work on 9b89391c?

Also, please turn on printk timestamp on all reports so that we can now
the timeline of things.

Thanks.

-- 
tejun
