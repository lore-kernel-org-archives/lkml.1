Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYAEGng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYAEGng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 01:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYAEGn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 01:43:29 -0500
Received: from gw.goop.org ([64.81.55.164]:52649 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYAEGn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 01:43:28 -0500
Message-ID: <477F26DD.8080604@goop.org>
Date: Fri, 04 Jan 2008 22:42:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <20080103092502.GA16096@elte.hu>
In-Reply-To: <20080103092502.GA16096@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
>
>   
>> +#define WARN_ON(condition) do_warn_on((unsigned long)(condition), __FILE__, \
>> +					 __LINE__, __FUNCTION__)
>>     
>
> hm. This passes in 4 arguments to do_warn_on().
>
> i think we could get away with no arguments (!), by using section 
> tricks. Firstly, we can get rid of __FUNCTION__ and replace it with a 
> ksyms lookup - that is fine enough. Secondly, we could put __FILE__ and 
> __LINE__ into a text section and key it up to the return address from 
> do_warn_on().
>   

BUG_ON already does this, and WARN_ON can reuse all the same machinery.

    J
