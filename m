Return-Path: <linux-kernel-owner+w=401wt.eu-S932311Ab0A2AFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0A2AFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142Ab0A2AFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:05:12 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:58259 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0A2AFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:05:11 -0500
Date: Thu, 28 Jan 2010 19:05:19 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
In-reply-to: <20100128153643.0fca3c51@nehalam>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B62263F.9000508@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B60707F.1000608@majjas.com> <20100127095614.14313677@nehalam>
 <4B608128.7090607@majjas.com> <4B6089C7.4010803@majjas.com>
 <4B61ADF1.7060705@majjas.com> <4B61BEA4.1030905@majjas.com>
 <20100128090835.0d93e53a@nehalam> <4B61DB79.4080703@majjas.com>
 <20100128223447.GC3109@del.dom.local> <4B621316.8070308@majjas.com>
 <20100128225621.GD3109@del.dom.local> <4B6216B9.1010802@majjas.com>
 <20100128153643.0fca3c51@nehalam>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2010 6:36 PM, Stephen Hemminger wrote:
> Please try this patch (and only this patch), on 2.6.33-rc5[*];
> none of the other patches that did not make it upstream because that
> confuses things too much.
>
> The code that checks for DMA mapping errors on receive buffers would
> not handle errors correctly.  I doubt you have these errors, but if you
> did then it would explain the problems.  The code has to be a little
> tricky and build mapping for new rx buffer before releasing old one,
> that way if new mapping fails, the old one can be reused.
>
> If it works for you, I will resubmit with signed-off.
>
> ---
> * If you want to use DMA debugging, then you will also need the match patch.
>    
Ok - I'll also be running with the recent sched fork vs. hotplug vs. 
cpuset namespaces patch (commit 
fabf318e5e4bda0aca2b0d617b191884fda62703) from tip. Without that I get 
an rcu hang.

My plan then is to run with your patch, the rcu patch & the dma debug 
patch, but disable dma debug for now and see of the problem recurs. If 
it works, I'll know in a couple of days. If not, perhaps sooner :(.

