Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbZDOPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbZDOPXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZDOPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:22:58 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:44942 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDOPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K7zXTM/BheSQQLSUA4PCtPX4OUZ339ds0bujgWHe5a7MgQbDabtg+cG5qCypLmP8LJ
         Poq7cAOFLrpyfKtaNJKEin8+VmtG/7FcMlDRpY9J7UvkH1iPWvGQOvKmA6sITkjJGxtR
         rqYgW9bUw95kLbihwF1xU31QqUlnX/7lT+qOM=
Date: Wed, 15 Apr 2009 19:52:37 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415152237.GA2846@lilem.mirepesht>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <alpine.LFD.2.00.0904150755170.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904150755170.4132@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-04-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 837c2c4..ecdb682 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -204,7 +204,13 @@ static void drv_read(struct drv_cmd *cmd)
>  
>  static void drv_write(struct drv_cmd *cmd)
>  {
> +	int this_cpu;
> +
> +	this_cpu = get_cpu();
> +	if (cpumask_test_cpu(this_cpu, cmd->mask))
> +		do_drv_write(cmd);
>  	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
> +	put_cpu();
>  }
>  
>  static u32 get_cur_val(const struct cpumask *mask)

Tested it and works.

Regards,
Ali
