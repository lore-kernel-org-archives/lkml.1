Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbXJYXZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbXJYXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXJYXZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:25:51 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49713 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbXJYXZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:25:50 -0400
Date: Thu, 25 Oct 2007 17:27:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Is gcc thread-unsafe?
In-reply-to: <fa.M4DOMggyrQmdTqekWSuw4xCxiTc@ifi.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Message-id: <4721265B.2060504@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.JbRGo0cQWncrcfKHmiNdvchsA50@ifi.uio.no>
 <fa.8qDECVaPIo7DWbjhQbyw6N5Infg@ifi.uio.no>
 <fa.M4DOMggyrQmdTqekWSuw4xCxiTc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 24 Oct 2007 21:29:56 -0700
> "David Schwartz" <davids@webmaster.com> wrote:
> 
>>> Well that's exactly right. For threaded programs (and maybe even
>>> real-world non-threaded ones in general), you don't want to be
>>> even _reading_ global variables if you don't need to. Cache misses
>>> and cacheline bouncing could easily cause performance to completely
>>> tank in some cases while only gaining a cycle or two in
>>> microbenchmarks for doing these funny x86 predication things.
>> For some CPUs, replacing an conditional branch with a conditional
>> move is a *huge* win because it cannot be mispredicted.
> 
> please name one...
> Hint: It's not one made by either Intel or AMD in the last 4 years...

It is a win if the branch cannot be effectively predicted, i.e. if the 
outcome is essentially random, as may occur with data-dependent 
conditionals. I've seen a doubling of performance on one workload using 
a predicated instruction instead of a branch on newer Xeons in such a case.

I suspect that if branch prediction fails often, the data dependency 
created by the cmov, etc. is less expensive than the pipeline flush 
required by mispredicts..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

