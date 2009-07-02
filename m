Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZGBVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZGBVQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZGBVQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:16:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbZGBVQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:16:30 -0400
Date: Thu, 2 Jul 2009 14:15:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, cpufreq@vger.kernel.org
Subject: Re: [PATCH][cpufreq][Powernow-k8] support family 0xf with 2 low
 p-states
Message-Id: <20090702141543.e6d8c0cd.akpm@linux-foundation.org>
In-Reply-To: <200907261055.25501.mark.langsdorf@amd.com>
References: <200907261055.25501.mark.langsdorf@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 10:55:25 -0500
Mark Langsdorf <mark.langsdorf@amd.com> wrote:
>
> Subject: [PATCH][cpufreq][Powernow-k8] support family 0xf with 2 low p-states

Please leave the subsystem identification text outside the []. 
Documentation/SubmittingPatches section 15 has details.


> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> @@ -215,7 +215,8 @@ struct pst_s {
>  
>  #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k8", msg)
>  
> -static int core_voltage_pre_transition(struct powernow_k8_data *data, u32 reqvid);
> +static int core_voltage_pre_transition(struct powernow_k8_data *data,
> +	u32 reqvid, u32 regfid);
>  static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvid);
>  static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);

It's fairly dopey to have static function declarations in a header file
- no other .c fail can _use_ them, so they may as well be tucked away
inside their .c file.  And that's only needed if the functions indeed
need to be forward-declared.


