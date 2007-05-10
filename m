Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXEJL2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXEJL2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbXEJL2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:28:35 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:64427 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbXEJL2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SvSidMiY/0pbXzEpxVVwssROL6On38hhkFaC8SZIc4e4Ciur4NrQZObNqcgjXCkFCaXhwjJn/Dqwdse/OHKp/synFVlntwUvZ40BfR9thG1AcnaziqabaYmS5Xrz5Yk3IwqJALi9/y2VpfVDzVmCuKuDjk4pgSTG5WMQOKpwYmM=
Message-ID: <464301D3.5060306@gmail.com>
Date: Thu, 10 May 2007 13:28:19 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: libata reset-seq merge broke sata_sil on sh
References: <20070510072005.GA27316@linux-sh.org>
In-Reply-To: <20070510072005.GA27316@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Paul Mundt wrote:
[--snip, thanks a lot for the detailed report--]
> However, if I go back before any of the reset changes were introduced,
> things were working fine, and there were no problems with waiting for
> the reset. Ideas?

Hmm... It worked so well on all my sil's.  I'm a bit puzzled because we
also failed the same condition before the change too.  The only change
is we're less patient with the initial tries but in the end we give more
than enough time to the device to prepare itself.

* Does your drive start spun down when it boots?  Can you post dmesg
with printk timestamp turned on with kernel prior to reset-seq merge?

* In ata_bus_softreset() and sata_std_hardreset(), there's msleep(150)
delay before checking the status post-reset.  Does increasing the delay
make any difference?  Please try to increase it exponentially till it
reaches 10sec.

-- 
tejun
