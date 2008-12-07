Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYLGP4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYLGP4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 10:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYLGPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 10:55:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbYLGPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:55:58 -0500
Message-ID: <493BF206.4070007@redhat.com>
Date: Sun, 07 Dec 2008 17:55:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/2] kvm: use cpumask_var_t for cpus_hardware_enabled
References: <200812072125.45757.rusty@rustcorp.com.au>
In-Reply-To: <200812072125.45757.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> This changes cpus_hardware_enabled from a cpumask_t to a cpumask_var_t:
> equivalent for CONFIG_CPUMASKS_OFFSTACK=n, otherwise dynamically allocated.
>
>  
> -static cpumask_t cpus_hardware_enabled;
> +static cpumask_var_t cpus_hardware_enabled

This isn't on stack, so it isn't buying us anything.

Is the plan to drop cpumask_t?  If so, we're penalizing non-stack users 
by forcing them to go through another pointer (and cacheline).



-- 
error compiling committee.c: too many arguments to function

