Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbXCSMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbXCSMOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXCSMOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:14:23 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:19993 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXCSMOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JiNfeOecaaScIK2TKVTf+MEiUKKPsoepwqWL92EZtJsEJ2cPy54azJqcLCQS3Kzu4IOZK3pyH211enMP3EPCD5vEBzl6jI+z+RmjrqgMtWxxAcay1J/FqbGkTzAnRKic+pTSbsCq1aW0Xx1ZrtTKrmsunzrNH7h0B1vAxAAI5Ak=
Message-ID: <45FE7E96.4050808@gmail.com>
Date: Mon, 19 Mar 2007 21:14:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tony Vroon <chainsaw@gentoo.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22] Add LED trigger to libata core
References: <20070318170605.3751D5B80F1@ganymede.vroon.org>	<45FE14BD.5090701@gmail.com> <20070319124616.2fb7494b@lxorguk.ukuu.org.uk>
In-Reply-To: <20070319124616.2fb7494b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 19 Mar 2007 13:42:37 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Tony Vroon wrote:
>>> This duplicates the IDE core LED trigger in the libata core.
>>> I plan to use this by allowing PMU LED control on G5 towers. My test platform 
>>> is a PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.
>> I think this fits better in libata-core.c::ata_qc_issue().  Can you move
>> it to there?
> 
> Gak. I'd rather it stayed out of ata_qc_issue() which is a critical path
> for performance.

The original place is in the critical path too.  It's just at the outer 
function which eventually calls ata_qc_issue() (the mapping is almost 
one to one).

> Our command issu is already too heavy and not all
> controllers have queueing to absorb that. How many controllers actually
> need this hook and can we not have ata_qc_issue_with_led() helpers for
> them ?

Our issue path is somewhat expensive due to SCSI -> ATA translation but 
I don't think it really matters on any modern cpu.  It can definitely 
hurt on embedded tho.  :-(

-- 
tejun
