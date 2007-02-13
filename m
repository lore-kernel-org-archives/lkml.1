Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXBMAVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXBMAVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBMAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:21:10 -0500
Received: from mail.velocitynet.com.au ([203.17.154.25]:47782 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574AbXBMAVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:21:08 -0500
Message-ID: <45D10460.6000903@iinet.net.au>
Date: Tue, 13 Feb 2007 11:20:48 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
 to	"array_for_each(index, array)"
References: <1171324070.1528.25.camel@localhost>
In-Reply-To: <1171324070.1528.25.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Now that most of the sizeof(array)/sizeof(array[0])
> conversions have been done (there are about 800 done
> and about another 130 left), perhaps it could be
> useful to change the code to use a define similar
> to the list_for_each
> 
> #define list_for_each(pos, head) \
> 	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
>         	pos = pos->next)
> 
> perhaps
> 
> #define array_for_each(index, array) \
> 	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)
> 

I like the idea, my only concern would be potential confusion.  That is, 
the list_for_each macro sets pos to each list_head in turn where 
array_for_each just sets the index /in to/ the array.  While I think the 
way you have is nicer, for compatibility between the two styles maybe 
something more like

  #define array_for_each(element, array) \
	for (int __idx = 0; __idx < ARRAY_SIZE((array)); \
		__idx++, (element) = &(array[__idx]))

would help.  Of course the other option is to name array_for_each 
something different to avoid comparisons with list_for_each.

--Ben.
