Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZLGAW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZLGAW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbZLGAWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:22:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbZLGAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:22:20 -0500
Message-ID: <4B1C4AB1.7040604@zytor.com>
Date: Sun, 06 Dec 2009 16:22:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: bifferos <bifferos@yahoo.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Kexec failure on RDC (and possibly other early x86) platforms
References: <371220.64690.qm@web27006.mail.ukl.yahoo.com> <4B1BE136.4090005@redhat.com>
In-Reply-To: <4B1BE136.4090005@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2009 08:52 AM, Avi Kivity wrote:
> On 12/06/2009 01:33 PM, bifferos wrote:
>> I've updated the patch to allow Kexec to work on RDC platforms
>> here:
>> http://bifferboard.svn.sourceforge.net/viewvc/bifferboard/slack/kernel/2.6.32/0003-kexec-fix.patch
>>
>>
>> I'm curious as to how one can detect the presence of the CR4
>> register in assembler, as I'm sure it's possible, but I've just
>> #ifndefed out the offending instruction in this patch and it
>> seems to work with this change.
>>    
> 
> One way is to execute the instruction and trap the #UD exception if it
> is not supported.  Not sure whether you have an IDT set up or whether
> your cpu traps on mov cr4.
> 
> If your cpu supports cpuid you can test for features that indicate bits
> in cr4 are available, for example VME, DE, PSE, PVI, and PAE.  If none
> are available you likely don't have cr4 (and even if you do, it's
> pointless to reset it).
> 

In general, I believe, existence of CPUID == existence of CR4.

(There were some late 486's which had CPUID, I believe they also had
CR4.)  The first-principles test of catching the trap is more direct,
though.  Inside the kernel we have read_cr4_safe() for that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

