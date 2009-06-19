Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZFSSvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZFSSvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZFSSve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:51:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50918 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZFSSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:51:33 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
	interface
To: davidel@xmailserver.org
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Date: Fri, 19 Jun 2009 14:51:21 -0400
Message-ID: <20090619183534.31118.30934.stgit@dev.haskins.net>
In-Reply-To: <alpine.DEB.1.10.0906181500350.32646@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906181500350.32646@makko.or.mcafeemobile.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Thu, 18 Jun 2009, Gregory Haskins wrote:
>
>>
>> But the fact is: I do not see any way to actually use your referenceless
>> POLLHUP release code in a race free way without doing something like I
>> propose in 3/4, 4/4.   Lets keep the discussion focused on that for now,
>> if we could.
>
> OK, since I got literally swamped by the amount of talks and patches over 
> this theoretically simple topic, would you mind  1) posting the global 
> patch over eventfd

Done.  Should show up as replies to this email.  These apply to v2.6.30 and
are devoid of any KVM-isms. :)

(Note-1: I've built and run these patches against additional kvm/irqfd
patches and verified they all work properly)

(Note-2: I included your POLLHUP patch as 1/3 since it currently only exists
in kvm.git, and is a pre-req for the other two)

> 2) describe exactly what races are you talking about


Covered in the patch headers (3/3 probably has the most detail)

 
> 3) explain why this should be any concern of eventfd at all?
>

To support any  in-kernel eventfd client that wants to get both "signal"
and "release" notifications (based on using your POLLHUP patch) in a
race-free way.  Without 2/3, 3/3, I cannot see how this can be done.  Yet
your 1/3 patch is an important enhancement (to at least one client).  I
suspect any other in-kernel users will find this a good feature as well.

Thanks Davide,
-Greg


