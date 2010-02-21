Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab0BUMML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 07:12:11 -0500
Received: from 8bytes.org ([88.198.83.132]:33006 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0BUMMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 07:12:09 -0500
Date: Sun, 21 Feb 2010 13:12:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] KVM: SVM: Don't call instruction emulator for
	invd and wbinvd
Message-ID: <20100221121208.GJ20833@8bytes.org>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com> <1266592990-8911-12-git-send-email-joerg.roedel@amd.com> <4B81028A.7080909@redhat.com> <20100221113708.GH20833@8bytes.org> <4B81205D.1070608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B81205D.1070608@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 02:00:29PM +0200, Avi Kivity wrote:
> On 02/21/2010 01:37 PM, Joerg Roedel wrote:
>> Weird. For some reason the Windows 7 XP emulation was executing wbinvd
>> which caused an nested intercept for the host level and the rip was not
>> advanced. So the nested guest did not advance and just produces wbinvd
>> intercepts all the time.
>>    
>
> Has the guest enabled wbinvd interception?  Perhaps not, so kvm has to  
> emulate wbinvd in the nested guest context, which is likely the only  
> case that we're called to do this.  So the problem might be in emulating  
> within the nested guest.

Probably, but this was running on nested-shadow where gva_to_gpa is
expected to work even when the vcpu is running in nested mode. I'll
check this again.

	Joerg

