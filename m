Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbXFENFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbXFENFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbXFENFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:05:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:5869 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373AbXFENFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:05:24 -0400
Message-ID: <46656051.2060207@openvz.org>
Date: Tue, 05 Jun 2007 17:08:33 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: menage@google.com, Andrew Morton <akpm@linux-foundation.org>, dev@sw.ru,
       vatsa@in.ibm.com, ebiederm@xmission.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 1/1] containers: implement nsproxy containers subsystem
References: <20070604185034.GA17970@sergelap.austin.ibm.com> <4665346F.20200@openvz.org> <20070605121358.GB22230@sergelap.austin.ibm.com>
In-Reply-To: <20070605121358.GB22230@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Pavel Emelianov (xemul@openvz.org):
>> Serge E. Hallyn wrote:
>>> >From 190ea72d213393dd1440643b2b87b5b2128dff87 Mon Sep 17 00:00:00 2001
>>> From: Serge E. Hallyn <serue@us.ibm.com>
>>> Date: Mon, 4 Jun 2007 14:18:52 -0400
>>> Subject: [PATCH 1/1] containers: implement nsproxy containers subsystem
>>>
>>> When a task enters a new namespace via a clone() or unshare(), a new
>>> container is created and the task moves into it.  This enables
>> I have a design question.
>>
>> How the child that has a new namespace guesses what id
>> this namespace has in containers?
> 
> parse /proc/$$/container

Ok.

> So more likely the parent would have to grab the cloned pid of the
> child, parse /proc/$$/container, then rename the container.

Child can happen to die before this and we'll have an orphaned
container. I mean, it will be deletable, but its name will be unknown.

Maybe its better to get the containers id from the pid of new task?

> -serge
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

