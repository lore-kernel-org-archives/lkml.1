Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYF2McG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYF2McG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYF2Mb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:31:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:19302 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYF2Mbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:31:55 -0400
Message-ID: <486780BA.6010202@qumranet.com>
Date: Sun, 29 Jun 2008 15:31:54 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Agner Fog <agner@agner.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com> <4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org> <4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org> <20080628200231.GA21259@one.firstfloor.org> <48677313.8000804@qumranet.com> <48677E39.6000001@firstfloor.org>
In-Reply-To: <48677E39.6000001@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Avi Kivity wrote:
>
>   
>> This is fixable. 
>>     
>
> Sure nearly everything is fixable, but why would you want to do that?
>
> For me the best fix currently seems to be to just not do that
> when it hurts.
>
>   

We already use sse in the kernel (raid), presumably disabling preemption 
there hurts some workloads.

With sse/avx gaining more features, we may see more requirements for 
kernel fpu.

>> We could change kernel_fpu_begin() not to disable
>> preemption, but instead set a task flag.  When we get the "no device"
>> fault, if the flag is set, save the fpu state into the kernel fpu save
>> area 
>>     
>
> What kernel fpu save area do you mean?
>   

A new one, of course.

-- 
error compiling committee.c: too many arguments to function

