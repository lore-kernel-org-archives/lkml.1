Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0BUMAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 07:00:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab0BUMAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 07:00:36 -0500
Message-ID: <4B81205D.1070608@redhat.com>
Date: Sun, 21 Feb 2010 14:00:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] KVM: SVM: Don't call instruction emulator for	invd
 and wbinvd
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com> <1266592990-8911-12-git-send-email-joerg.roedel@amd.com> <4B81028A.7080909@redhat.com> <20100221113708.GH20833@8bytes.org>
In-Reply-To: <20100221113708.GH20833@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2010 01:37 PM, Joerg Roedel wrote:
> On Sun, Feb 21, 2010 at 11:53:14AM +0200, Avi Kivity wrote:
>    
>> On 02/19/2010 05:23 PM, Joerg Roedel wrote:
>>      
>>> There is an intercept for WBINVD and INVD in SVM so we don't
>>> need the instruction emulator. The primary reason is that
>>> the current instruction emulator fails to emulate these
>>> instructions and the rip is not advanced.
>>>
>>>        
>> The bios (at least bochs bios) does have wbinvd, so this ought to work.
>>      
> Weird. For some reason the Windows 7 XP emulation was executing wbinvd
> which caused an nested intercept for the host level and the rip was not
> advanced. So the nested guest did not advance and just produces wbinvd
> intercepts all the time.
>    

Has the guest enabled wbinvd interception?  Perhaps not, so kvm has to 
emulate wbinvd in the nested guest context, which is likely the only 
case that we're called to do this.  So the problem might be in emulating 
within the nested guest.

-- 
error compiling committee.c: too many arguments to function

