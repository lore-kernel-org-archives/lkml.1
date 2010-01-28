Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745Ab0A1PKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0A1PKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710Ab0A1PKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:10:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:51146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0A1PKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c/mfAnL2S4WcnM+vY3Pq55CYCXw2S6rTIfUkOOmMWZPOrwv1lq6/EqRWm3LgAXuZa1
         jAsYCsrR//Ef2tPW3ByJd/8n9mSIykKMbqIWGwV9zW+2V6x+wU0qlovrnxys+Om7iBA2
         lMCTUoida4LEMeY7+qzRiRjkxjgsHIxXhzbfc=
Date: Thu, 28 Jan 2010 18:10:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [RFC][x86] move notify_die from nmi.c to traps.c
Message-ID: <20100128151025.GA5338@lenovo>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com> <1264622622-5778-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264622622-5778-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 03:03:40PM -0500, Don Zickus wrote:
...
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 3339917..3b98dd3 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -400,6 +400,11 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
>  								== NOTIFY_STOP)
>  			return;
> +
> +	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> +	        			                == NOTIFY_STOP)
> +	                return;
> +
>  #ifdef CONFIG_X86_LOCAL_APIC
>  		/*
>  		 * Ok, so this is none of the documented NMI sources,
> --

Hi Don, I suppose this notify_die should be in CONFIG_X86_LOCAL_APIC
section?
 
	-- Cyrill
