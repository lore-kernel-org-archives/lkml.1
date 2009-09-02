Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZIBT4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZIBT4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZIBT4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:56:16 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:43471 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZIBT4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cdLl7QOCxmk8mGT7RASQP+hxUG02BhiMf4nSyg77292+R08bLzhopI2CrNpJQ3QkdP
         9P/FAMOHOm6+MnYaFft8Y7tQuVXMOZCfNQSLjtnHEQDkzI8Q8eF2IQlwA3kRubO9Sp6H
         by9EGla2zAq/c0bEVvuPMOouJcuwixxAOAV64=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.00.0909021226160.10279@chino.kir.corp.google.com>
References: <20090902060911.GA5728@in.ibm.com>
	 <alpine.DEB.1.00.0909012326290.31814@chino.kir.corp.google.com>
	 <20090902080346.GB3806@in.ibm.com>
	 <alpine.DEB.1.00.0909021226160.10279@chino.kir.corp.google.com>
Date: Thu, 3 Sep 2009 01:26:18 +0530
X-Google-Sender-Auth: a4305f671635f528
Message-ID: <661de9470909021256i569261bxbe1523d8e37b5b14@mail.gmail.com>
Subject: Re: [PATCH v2] Fix fake numa on ppc
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Ankita Garg <ankita@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 1:06 AM, David Rientjes<rientjes@google.com> wrote:
> On Wed, 2 Sep 2009, Ankita Garg wrote:
>
>> Currently, the behavior of fake numa is not so on x86 as well? Below is
>> a sample output from a single node x86 system booted with numa=fake=8:
>>
>> # cat node0/cpulist
>>
>> # cat node1/cpulist
>>
>> ...
>> # cat node6/cpulist
>>
>> # cat node7/cpulist
>> 0-7
>>
>> Presently, just fixing the cpu association issue with ppc, as explained
>> in my previous mail.
>>
>
> Right, I'm proposing an alternate mapping scheme (which we've used for
> years) for both platforms such that a cpu is bound (and is set in
> cpumask_of_node()) to each fake node with which it has physical affinity.
> That is the only way for zonelist ordering in node order, task migration
> from offlined cpus, correct sched domains, etc.  I can propose a patchset
> for x86_64 to do exactly this if there aren't any objections and I hope
> you'll help do ppc.

Sounds interesting, I'd definitely be interested in seeing your
proposal, but I would think of that as additional development on top
of this patch

Balbir Singh.
