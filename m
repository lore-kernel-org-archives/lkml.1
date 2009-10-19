Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZJSPcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZJSPcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbZJSPcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:32:06 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:53729 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbZJSPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:32:04 -0400
Message-ID: <4ADC8677.7000607@anirban.org>
Date: Mon, 19 Oct 2009 08:32:07 -0700
From: Anirban Sinha <ani@anirban.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: Kernel oops when clearing bgp neighbor info with TCP MD5SUM enabled
References: <Pine.LNX.4.64.0910081514050.18315@sleet.zeugmasystems.local> <20091008.155429.02850661.davem@davemloft.net> <Pine.LNX.4.64.0910081622400.18315@sleet.zeugmasystems.local> <20091008.175703.83006470.davem@davemloft.net> <Pine.LNX.4.64.0910171035340.2364@sleet.zeugmasystems.local> <4ADA7EDC.5010402@anirban.org> <4ADB7856.7000803@anirban.org> <20091019121327.GA11423@redhat.com>
In-Reply-To: <20091019121327.GA11423@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Once upon a time, like on 09-10-19 5:13 AM, Oleg Nesterov wrote:
> Hi Anirban,
> 
> On 10/18, Anirban Sinha wrote:
>>
>> I have a question for you. The queue_work() routine which is called from
>> schedule_work() does a put_cpu() which in turn does a enable_preempt(). Is
>> this an attempt to trigger the scheduler?
> 
> No. please note that queue_work() does get_cpu() + put_cpu() to protect
> against cpu_down() in between.

grrr! Ah yes, my eyes failed me (or it saw what I wanted it to see :)). You do have a get_cpu() and put_cpu() together in the same code path. I guess I will have to keep looking at inet_twdr_hangman(). 

>> Is is
>> it illegal to schedule a work function from within a timer callback?
> 
> Yes sure.

hmm. may be in that case, that function needs to be re-written. 

> I'd suppose that this unbalance comes from inet_twdr_hangman() pathes.
> 
> Could you verify this?

I'll keep looking. Thanks for the help Oleg. 

Ani

