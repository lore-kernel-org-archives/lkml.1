Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZJRISL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZJRISL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZJRISK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:18:10 -0400
Received: from claw.goop.org ([74.207.240.146]:42319 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZJRISJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:18:09 -0400
Message-ID: <4ADACF40.20700@goop.org>
Date: Sun, 18 Oct 2009 17:18:08 +0900
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       arch/x86 maintainers <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Subject: Re: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
References: <4AD6B1F0.6030904@goop.org>	 <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>	 <1f1b08da0910151832m59d14ac2i4add6555d6a1208a@mail.gmail.com>	 <4AD7E440.2030503@goop.org> <1255715898.5135.9.camel@localhost.localdomain>
In-Reply-To: <1255715898.5135.9.camel@localhost.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/09 02:58, john stultz wrote:
>> (I can think of plenty of ways of doing it incorrectly, where you'd get
>> apparent non-monotonicity regardless of the quality of the time source.)
>>     
> There's been some interesting talk of creating a more offset-robust TSC
> clocksource using a per-cpu TSC offsets synced periodically against a
> global counter like the HPET.  It seems like it could work, but there
> are a lot of edge cases and it really has to be right all of the time,
> so I don't think its quite as trivial as some folks have thought. But it
> would be interesting to see!
>   

Xen and KVM do this already.  The host system provides the tsc rate and
offset information for each cpu so that the guest kernel can compute a
global system time (ns since boot) from the tsc.

I suspect its quite difficult to guarantee that you get completely
monotonic results if the tscs are at different rates, but if they're the
same rate but merely offset it should give completely OK results.

    J
