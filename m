Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZD0Gds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZD0Gds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZD0Gdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:33:39 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:60609 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbZD0Gdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CipXQ0UFFaqLgaV/zZikkk82IVAcNGX5gRUoQwenOK2jPY97oR7lBMn8gDRsFjgDrA
         86uyJtiomObBeox5hmNMLw65KT0UosPY2R7Yfyd1EdodDzDt2lQhVlKblhbMv5EV0nfx
         XERUr/Ris3iUyN4Vwv/+XRp0zhZBUXym47sSk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
	 <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
	 <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
Date: Mon, 27 Apr 2009 08:33:34 +0200
Message-ID: <40a4ed590904262333k13dd3630t8d241eb30782bbab@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David

On Sun, Apr 26, 2009 at 9:55 PM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 25 Apr 2009, Zeno Davatz wrote:
>
>> Couldn't you start killing processes at an earlier stage? It seems to
>> me that the stage when processes are being killed by oom_killer is a
>> bit late in the game, when the machine is anyway very close to the
>> freezing point. I mean we had these messages of oom_kill several times
>> in our /var/log/kernel/current over a distributed amount of time.
>>
>
> The oom killer serves a very well-defined purpose: to kill a
> memory-hogging task when your system (or cpuset, memory controller) is out
> of memory.

Maybe sometimes to late in the process when the system _is_ already
out of memory ;) - because one task just uses 99% of the memory.

> When it kills a task, it also allows access to memory reserves
> that allow it to allocate beyond each allowable zone's min watermark.
> This is intended to allow the task to quickly exit.

Can you recommend a link where I can read up on this issue / problem?
It seems to me when the system is already out of memory it does not
have enough "memory" for freeing itself for some fresh memory,
specially if there is one application, that uses about 99% of the
memory. I would suggest, that in such a case it should just kill the
task that uses the most memory.

> There is work being done on a per-cgroup lowmem notifier which would allow
> userspace to poll() on a device file and be notified of low memory
> situations so that it can react on its own (like killing a low priority
> task, expanding a cpuset, increasing a memcontroller limit, etc.)

This sounds very interesting. Would this be working together with
udev? How would it got about to kill a task like "Apache" or "Ruby" or
any other application that is running on the linux machine.

Best
Zeno
