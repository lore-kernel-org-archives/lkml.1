Return-Path: <linux-kernel-owner+w=401wt.eu-S1763348AbYDVNYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348AbYDVNYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYDVNYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:24:14 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:10537 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753399AbYDVNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=J5LYTiB8xYM0jiOQ4Gob57cHtA+pZ765SL/hM2x+OBxRrN1do/I0wbFOB9K45UheOT02dz19fpdJblBZgrTfDJLMBjIkrVPg4TC5Rz9TmzhNf1OvcpAzC0OzIc0cFRsgymulKINZySAtAhh70u9vUTvQLOtIQ7I6X7ZhSxP+ZG4=
Message-ID: <480DE6F5.8060403@gmail.com>
Date: Tue, 22 Apr 2008 22:24:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com>
In-Reply-To: <480DE3C4.5@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sergei Shtylyov wrote:
>    ADMA is not SFF-8038i compilant, it's the IDE DMA spec of its own. 
> And I'm seeing references to libata-sff.c... confusing.

In libata, SFF is used for controllers which have TF interface and BMDMA 
is used for the BMDMA part of SFF-8038i.  I think this is the source of 
confusion here.

>    Looks like there's no clean separation within libata-sff.c itself 
> between SFF-8038i (BMDMA spec) and IDE registers itself -- that confused 
> me: at first I thought there's a big issue with a patch. :-/
> 
>    Jeff, Tejun, what "sff" in the file name actually means? Isn't it 
> strange that the drivers lacking DMA support or not really compliant 
> with SFF-8038i have to link with this file?

Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma) and 
bmdma is acceptable, hopefully, right?

Thanks.

-- 
tejun
