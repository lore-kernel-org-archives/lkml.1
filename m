Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZFVO3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZFVO3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFVO33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:29:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49929 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZFVO33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:29:29 -0400
Message-ID: <4A3F957A.6000501@redhat.com>
Date: Mon, 22 Jun 2009 17:30:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com> <4A3F8170.7000508@gmail.com> <20090622131351.GE12867@redhat.com> <4A3F84FD.3090700@gmail.com>
In-Reply-To: <4A3F84FD.3090700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 04:19 PM, Gregory Haskins wrote:
> The question to ask is whether a guest can influence that condition.  If
> they can, its an attack vector to crash the host.  I suspect they can't,
> however.  Therefore, your recommendation is perhaps a good approach so
> this condition cannot ever go unnoticed.  Avi?
>    

No, this is host memory in the emulator context, allocated as unsigned 
long.  But this is on x86 which isn't sensitive to alignment anyway.  
It's unlikely that other achitectures will supply unaligned pointers.

We ought to convert the interface to pass a value anyway.

-- 
error compiling committee.c: too many arguments to function

