Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbYDWBvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbYDWBvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYDWBvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:51:17 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:18985 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbYDWBvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tiNMeuOykxcnhr/7JhAbgomjrsy/2kZmQlW9jZ44jRzxWLM29PR61iFdUtUnh5nkgQ4a0dQVmi9L45gMcuBj9QR2c+RBUuN+aktX8cF7jYvtpDaTbBxcTceSmpLyduFgNE3cQ/uMn49kKQDAt/VrbK+raf+/nvM2QZEkKutmbpI=
Message-ID: <480E9609.1070302@gmail.com>
Date: Wed, 23 Apr 2008 10:51:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [bisected] Latest git not seeing HD with sata_nv
References: <adazlrlcw9f.fsf@cisco.com> <adave29cqgh.fsf@cisco.com> <adar6cxcpur.fsf@cisco.com>
In-Reply-To: <adar6cxcpur.fsf@cisco.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> FWIW, the patch below also makes my box start working again...  I have
> no idea what the right fix is, given that bug 3352 mostly seems to be
> about nforce2 and nforce3, and my box has a more modern nvidia chipset:
> 
>     00:04.0 IDE interface [0101]: nVidia Corporation MCP55 IDE [10de:036e] (rev a1)
> 
> Anyway, it seems 305d2a1a broke the logic that nv_hardreset() relies on
> when it doesn't let sata_sff_hardreset() set class.

Ah... okay now I see it.  I neglected whole class of hardresets which 
was using &dummy as class.  I'll verify and prep a patch soon.  Thanks.

-- 
tejun
