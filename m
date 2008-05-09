Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYEIKLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYEIKLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYEIKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:11:32 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:55666 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYEIKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MPc/8dFn6OmD/965PfqLy6sD6TsCQizPCHaMU+xbcyjDLyJj9yrFCg4lhO3q2VDvo8QDgEV+hAy8dM9R0wIu+O3TDJfJ/tj1iN71JOedeEG60vii0/qBv7KY6Ngeqs3jSfv7v9R07GVW2+caiXa0gDEaSD8w5+ErvPxurDuxIVY=
Date: Fri, 9 May 2008 18:09:44 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Travis <travis@sgi.com>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509100944.GK2543@hacking>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509095837.GB19617@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:58:37AM +0200, Ingo Molnar wrote:
>
>
>i've got the one below queued up but it's stalled as it could easily be 
>wrong and there's no ack from James yet and there's been discussion back 
>and forth. James, what do you suggest?
>

Well, 'phys_cpu_present_map' of arch/x86/mach-voyager/voyager_smp.c is
only used in arch/x86/mach-voyager/voyager_smp.c, other files under
arch/x86/mach-voyager/ not.

And there's also a global 'phys_cpu_present_map', and is widely used
by files under arch/x86/kernel/.

I check these two 'phys_cpu_present_map''s types, the one used by
arch/x86/kernel/ files is not the one defined in
arch/x86/mach-voyager/voyager_smp.c. So
'arch/x86/mach-voyager/voyager_smp.c::phys_cpu_present_map' should become
static.

Thanks.

