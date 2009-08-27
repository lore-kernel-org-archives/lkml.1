Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbZH0Cqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbZH0Cqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087AbZH0Cqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:46:45 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:64919 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbZH0Cqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:46:44 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 22:46:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=P9VWEmY2+kJuWUvKhwVJy2J7eTy3khaImfYMUrnpVuhCSEJq3ImOoeY/PI1PR3SONB
         sfnlxztQGXpJh1HIvIPDiVYvX+Pf2oIP6yMTm0YqwYhG0rq6WFvLAtQe1KXkDjeIcJs+
         bE+1HTMDp0bM4NkoQJdtBxIa8Q86wAF5f0FwI=
Message-ID: <4A95F212.5060008@gmail.com>
Date: Wed, 26 Aug 2009 20:40:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
References: <200801140019.20668.g.chulkov@jacobs-university.de>	<20080115025435.1e21b703.akpm@linux-foundation.org>	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>	<4794501E.90306@gmail.com>	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>	<47949AA4.9090601@gmail.com> <20080121141425.45aa9c61@lxorguk.ukuu.org.uk> <4794ACAF.70505@gmail.com> <4794AD3F.40309@gmail.com>
In-Reply-To: <4794AD3F.40309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2008 08:33 AM, Tejun Heo wrote:
> Tejun Heo wrote:
>> IMHO, losing media error information is much better than locking up a
>> machine hard.  We can start white listing known good controllers but I'm
>> skeptical how much benefit it will bring.
>
> Just a data point, even ICHs lock up after PHY event if the wrong TF
> register is accessed.  I just don't think tempting with TF regs after
> timeout is worth the cost.

Nvidia CK804 SATA controllers appear to also explode on reading TF 
registers after media errors in certain cases. (They tend to either 
lockup the machine or throw HyperTransport timeout machine check 
exceptions). I suspect those error paths aren't well tested (except that 
it even explodes in Windows with the default Microsoft IDE driver, when 
reading a scratched DVD on a SATA drive, for example.)
