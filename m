Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYHMTjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYHMTjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHMTjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:39:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYHMTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:39:32 -0400
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: invalidate caches before going into suspend
From: Andi Kleen <andi@firstfloor.org>
References: <200808131141.18003.mark.langsdorf@amd.com>
Date: Wed, 13 Aug 2008 21:39:28 +0200
In-Reply-To: <200808131141.18003.mark.langsdorf@amd.com> (Mark Langsdorf's message of "Wed, 13 Aug 2008 11:41:17 -0500")
Message-ID: <877iak1z7z.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf <mark.langsdorf@amd.com> writes:
> @@ -93,11 +93,11 @@ static inline void play_dead(void)
>  static inline void play_dead(void)
>  {
>  	idle_task_exit();
> -	wbinvd();
>  	mb();
>  	/* Ack it */
>  	__get_cpu_var(cpu_state) = CPU_DEAD;
>  
> +	wbinvd();

You should put the mb() (or just a barrier()) directly above the wbinvd(), 
otherwise the compiler is free to reorder this behind your back again
and move the store down after the wbinvd.

-Andi
