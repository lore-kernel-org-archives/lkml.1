Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZDYIdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZDYIdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZDYIcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:32:53 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:65498 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZDYIcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m8EOxstATDol5u9eXS+wHHBSabiYqp6iBqCx35uMl7gKDxRLbfXHgkDdDFOF3pHPzU
         rOYWH2SCMQdhsYFFIWk7wwVOyY8JhPowFhsRz89TGqyJuvmIcAzK7+1O9piJWl7mz+87
         PfYYeKVpfLvvaSDOqKjj3pPPFSTkUf2Wwl94c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
Date: Sat, 25 Apr 2009 10:32:48 +0200
Message-ID: <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
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

On Fri, Apr 24, 2009 at 9:26 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 24 Apr 2009, Zeno Davatz wrote:
>
>> > These types of livelocks are possible with the oom killer when a task
>> > fails to exit, one possible way to fix that is to introduce an oom killer
>> > timeout such that if a task fails to exit for a pre-defined period of
>> > time, the oom killer will choose to kill another task in the hopes of
>> > future memory freeing.  The problem with that approach, however, is that
>> > the hung task can consume an enormous amount of memory that will never be
>> > freed.
>>
>> Thanks for the hint! Is there another solution as well? Any
>> Kernel-Upgrades in the Pipeline? What does Linus think about this?
>>
>
> I had a patchset that added a timeout for oom killed tasks now that the
> entire oom killer is serialized, but it only really works well if your
> memory is so partitioned (such as with cpusets or the memory controller)
> that it actually makes sense to continue.  With global system-wide ooms
> such as yours, it would only result in a long chain of kills with no
> positive outcome.

Couldn't you start killing processes at an earlier stage? It seems to
me that the stage when processes are being killed by oom_killer is a
bit late in the game, when the machine is anyway very close to the
freezing point. I mean we had these messages of oom_kill several times
in our /var/log/kernel/current over a distributed amount of time.

Of course we now also set a roadblock to our main application
(http://ch.oddb.org) that kills the application if it uses more then
10 GB of memory.

Best
Zeno
