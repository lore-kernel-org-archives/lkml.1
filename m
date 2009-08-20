Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZHTRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZHTRiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZHTRiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbZHTRiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:38:17 -0400
Message-ID: <4A8D8A28.2050004@redhat.com>
Date: Thu, 20 Aug 2009 20:38:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 07:20 PM, Davide Libenzi wrote:
>
> I briefly looked at this while in vacation, although I did not reply
> hoping the horrible feeling about this code would go away.
> It didn't.
> I find this to be an ugly and ad-hoc multiplexing of eventfd with added
> functionalities of questionable general use.
> I'm pretty sure you can do better on KVM side, to solve the problem w/out
> littering eventfd.
>
>    

While we could argue about this my feeling is that we should drop this, 
at least until we can quantify what benefit it has and whether there are 
any Davide-acceptable alternatives.

In the meanwhile, we can let vhost-net support edge-triggered interrupts 
only, let qemu terminate those eventfds and convert then to 
level-triggered interrupts (which it can then inject using the existing 
ioctl).  It will keep vhost-net and kvm simpler at the cost of some 
performance penalty to guests using level interrupts.  These suck anyway 
so we'll point users at msi.

-- 
I have a truly marvellous patch that fixes the bug which thisb
signature is too narrow to contain.

