Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYEaAt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYEaAt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYEaAtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:49:17 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:39212 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYEaAtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QewFJDuSwSJXuulOTBlMPx2YamBuhaeJxTnRzRY1Bc62Qj7PmNCdd3DzQ4VEmOk+2WWu42ZEddFDp0OaWdnfjLG15XWl7H5x0CdT5cVcgMO1mA6us26Mozs8F3gcT32PZxRcHOoACC12BVKNAPwqCNjEmvabAWDkHKqqa5nm/vQ=
Message-ID: <4840A085.2080101@gmail.com>
Date: Sat, 31 May 2008 09:49:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
CC: Peer Chen <pchen@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200805291654.03617.volker.armin.hemmann@tu-clausthal.de> <483F804F.1@gmail.com> <200805301243.39751.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200805301243.39751.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemmann, Volker Armin wrote:
> On Freitag, 30. Mai 2008, Tejun Heo wrote:
>> Hello,
>>
>> Hemmann, Volker Armin wrote:
>>> -AHCI+nomsi: boots fine. Works fine. But: I still can not enable ncq
>>> -AHCI+msi: the usual. No harddisks found, waiting for the timeouts, then
>>> kernel panic because of missing root.
>>>
>>> -NON-RAID/IDE+msi: works fine. No delays. No NCQ (not surprising since
>>> mobos handbook says that AHCI mode is required).
>>> -NON-RAID/IDE+nomsi: see above.
>> So, sans NCQ, the only remaining issue is MSI, right?  Peer Chen, please
>> lemme know which controllers are affected by this MSI problem and where
>> the problem lies.
> 
> this is correct.
> 
>> The controller is not reporting NCQ capability in its cap register
>> (flags: line contains ncq if the controller is), so NCQ is not enabled.
> 
> ah, I thought all AHCI chipsets support NCQ (and the board's handbook lists it 
> as feature) thanks for the explanation.

It could be that the controller has ahci support but it just forgets to
set the corresponding cap bit.  Peer Chen, Kuan Luo, can you guys please
comment on the 64bit and ncq problems?

Thanks.

-- 
tejun
