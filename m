Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYA3C2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYA3C2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYA3C2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:28:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10155 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYA3C2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=s8tjMG5KPARw9m3CWHym90ANjXBICSsQSq91WL5K1GF1hsUKTCTCe+vQFFUEFG0PS5UMdZDaD3vjy8Lomqe5jZ487atHpCdFkUJxPBMEYNdyajS3+LuUdADWNMTAen+RJSVSwRljTX2x7t4RAIzn5T+lLHfaXEcZyTmV72DrWDQ=
Message-ID: <479FE0D1.1030607@gmail.com>
Date: Wed, 30 Jan 2008 11:28:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Kuan Luo <kluo@nvidia.com>, Allen Martin <AMartin@nvidia.com>
Subject: Re: [PATCH] sata_nv: fix for completion handling
References: <479FD88F.8090605@shaw.ca>
In-Reply-To: <479FD88F.8090605@shaw.ca>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This patch is based on an original patch from Kuan Luo of NVIDIA,
> posted under subject "fixed a bug of adma in rhel4u5 with HDS7250SASUN500G".
> His description follows. I've reworked it a bit to avoid some unnecessary
> repeated checks but it should be functionally identical.
> 
> "The patch is to solve the error message "ata1: CPB flags CMD err,
> flags=0x11" when testing HDS7250SASUN500G in rhel4u5.
> I tested this hd in 2.6.24-rc7 which needed to remove the mask in
> blacklist to run the ncq and the same error also showed up. 
> 
> I traced the  bug and found that the interrupt finished a command (for
> example, tag=0) when the driver got that adma status is
> NV_ADMA_STAT_DONE  and  cpb->resp_flags is NV_CPB_RESP_DONE.
> However, For this hd, the drive maybe didn't clear bit 0 at this moment.
> It meaned the hardware  had not completely finished the command.
> If at the same time  the driver freed the command(tag 0) and sended
> another command (tag 0), the error happened.
> 
> The notifier register is 32-bit register containing notifier value.
> Value is bit vector containing one bit per tag number (0-31) in
> corresponding bit positions (bit 0 is for tag 0, etc). When bit is set
> then ADMA indicates that command with corresponding tag number completed
> execution.
> 
> So i added the check notifier code. Sometimes i saw that the notifier
> reg set some bits  , but the adma status set NV_ADMA_STAT_CMD_COMPLETE
> ,not NV_ADMA_STAT_DONE. So i added the NV_ADMA_STAT_CMD_COMPLETE check
> code."
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Any chance this fixes the FLUSH problem?

-- 
tejun
