Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0BULhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 06:37:12 -0500
Received: from 8bytes.org ([88.198.83.132]:33625 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0BULhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 06:37:10 -0500
Date: Sun, 21 Feb 2010 12:37:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] KVM: SVM: Don't call instruction emulator for
	invd and wbinvd
Message-ID: <20100221113708.GH20833@8bytes.org>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com> <1266592990-8911-12-git-send-email-joerg.roedel@amd.com> <4B81028A.7080909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B81028A.7080909@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 11:53:14AM +0200, Avi Kivity wrote:
> On 02/19/2010 05:23 PM, Joerg Roedel wrote:
>> There is an intercept for WBINVD and INVD in SVM so we don't
>> need the instruction emulator. The primary reason is that
>> the current instruction emulator fails to emulate these
>> instructions and the rip is not advanced.
>>    
>
> The bios (at least bochs bios) does have wbinvd, so this ought to work.

Weird. For some reason the Windows 7 XP emulation was executing wbinvd
which caused an nested intercept for the host level and the rip was not
advanced. So the nested guest did not advance and just produces wbinvd
intercepts all the time.

	Joerg

