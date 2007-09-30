Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbXI3Ra4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbXI3Ra4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbXI3Rar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:30:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:61670 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbXI3Raq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Fe1I6LFvhNlGIvxJreCshoBmCntDgJBVayuitkLuSSSm14I1DadYR+J8qsARTR1xgiCY25wBuw7xKQd8ReqaoYuEOjk2/lFxZhbi5z6S/tvVKQRMMCQek5/Gw/nkVjBqJPAhG2H867zlTDgI6zQn3cT9oTxvJAxs2QKAnrddknQ=
Message-ID: <46FFDCE5.4060900@gmail.com>
Date: Sun, 30 Sep 2007 10:29:09 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Jeff Garzik <jeff@garzik.org>, Paolo Ornati <ornati@fastwebnet.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>	<20070930152908.1f58d39d@the-village.bc.nu> <20070930164610.20818867@localhost> <46FFBB2D.6060004@garzik.org> <46FFDC5A.7070509@rtr.ca>
In-Reply-To: <46FFDC5A.7070509@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> Paolo Ornati wrote:
>>> I have this problem only with XFS, and even with XFS it goes away
>>> mounting with "nobarrier"...
>>
>> This last is an interesting datapoint.
>>
>> I wonder if libata has a generic problem with NCQ + FLUSH CACHE.
> 
> Yeah, that's pretty suspicious.  Prior to issuing a FLUSH_CACHE op,
> one must first drain all outstanding NCQ commands (and not issue new ones).
> 
> I'm sure the code must *try* to do that, but perhaps there's a bug in
> there?
> Or just another drive bug?

If there was such a bug, the aborted commands list should contain both
FPDMA commands and FLUSH commands.  I don't think command filtering
itself is broken.  Possibly another quirky firmware but it's strange
that this is the only Seagate drive showing this problem.

Thanks.

-- 
tejun
