Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZK2Kn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZK2Kn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 05:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZK2Kn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 05:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZK2Kn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 05:43:26 -0500
Message-ID: <4B125051.6010506@redhat.com>
Date: Sun, 29 Nov 2009 12:43:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b
 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix>
In-Reply-To: <87skbzvdgd.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2009 11:56 PM, Nix wrote:
> So I installed my first KVM guest image (a prerelease of Ubuntu 9.10
> that I had lying around) this morning (through virt-manager, as it
> happens). Everything worked fine, the install was searingly fast
> compared to the UML virtual machines I'm used to.
>
> I got back to it this evening, restarted the VM, and found that it had
> suddenly slowed right down again, with one CPU being saturated with work
> even when nothing was happening. Looking at the syslog shows (what would
> be but for ratelimit) incredible numbers of these messages being logged:
>
> Nov 27 21:44:00 spindle info: [444857.792205] device vnet0 entered promiscuous mode
> Nov 27 21:44:00 spindle info: [444857.794347] linux-net: port 2(vnet0) entering learning state
> Nov 27 21:44:03 spindle warning: [444860.856640] __ratelimit: 928705 callbacks suppressed
> Nov 27 21:44:03 spindle err: [444860.856729] emulation failed (pagetable) rip 7f3845f36a7b 66 0f 7f 07
>    

66 0f 7f 07              movdqa %xmm0,(%rdi)

which we don't emulate.

Can you, using the qemu monitor, see where the guest is trying to write?

   (qemu) info registers
   (qemu) x/30i $eip - 20


-- 
error compiling committee.c: too many arguments to function

