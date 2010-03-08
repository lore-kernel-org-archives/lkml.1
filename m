Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0CHXL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:11:58 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58456 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0CHXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:11:54 -0500
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>,
       john cooper <john.cooper@third-harmonic.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mtosatti@redhat.com,
       zamsden@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com>
	<4B8BB6FA.1000505@oss.ntt.co.jp> <20100301125223.GI16909@redhat.com>
	<4B8BBE61.3020503@oss.ntt.co.jp> <20100301132609.GJ16909@redhat.com>
	<4B8C11DC.1060004@third-harmonic.com>
	<20100302072809.GS16909@redhat.com> <4B936B27.1050207@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Mar 2010 15:11:49 -0800
In-Reply-To: <4B936B27.1050207@redhat.com> (Avi Kivity's message of "Sun\, 07 Mar 2010 11\:00\:23 +0200")
Message-ID: <m1aauipfwq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 03/02/2010 09:28 AM, Gleb Natapov wrote:
>> On Mon, Mar 01, 2010 at 02:13:32PM -0500, john cooper wrote:
>>    
>>> Gleb Natapov wrote:
>>>
>>>      
>>>> Think about what happens if in the middle of
>>>> instruction emulation some data from device emulated in userspace is
>>>> needed. Emulator should be able to tell KVM that exit to userspace is
>>>> needed and restart instruction emulation when data is available.
>>>>        
>>> setjmp/longjmp are useful constructs in general but
>>> IME are better suited for infrequent exceptions vs.
>>> routine usage.
>>>      
>> Exception condition during instruction emulation _is_
>> infrequent.
>
> Well, with mmio you'd expect it to happen every read access.

Of course if you are hitting that kind of case very often
you don't want to do the emulation in the kernel but
in userspace so you don't have to take the context switch
overhead and everything else.

I know running emulations in userspace was for dosemu
the difference between a 16 color ega emulation on X
that was unusable to one that was good enough to play video
games like wolfenstein and doom.

Eric

