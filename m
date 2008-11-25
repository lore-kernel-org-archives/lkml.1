Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYKYKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYKYKJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYKYKJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:09:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60218 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYKYKJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:09:05 -0500
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc6] oprofile: "opcontrol --start" output two warnings
From: Andi Kleen <andi@firstfloor.org>
References: <20081125121212.26C3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Tue, 25 Nov 2008 11:09:08 +0100
In-Reply-To: <20081125121212.26C3.KOSAKI.MOTOHIRO@jp.fujitsu.com> (KOSAKI Motohiro's message of "Tue, 25 Nov 2008 12:18:22 +0900 (JST)")
Message-ID: <87ljv8ce2j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>
> Index: b/arch/x86/oprofile/op_model_p4.c
> ===================================================================
> --- a/arch/x86/oprofile/op_model_p4.c	2008-11-24 06:20:04.000000000 +0900
> +++ b/arch/x86/oprofile/op_model_p4.c	2008-11-24 06:29:09.000000000 +0900
> @@ -399,6 +399,8 @@ static void p4_fill_in_addresses(struct 
>  	unsigned int i;
>  	unsigned int addr, cccraddr, stag;
>  
> +	get_cpu();

The whole thing seems broken anyways because the only caller of
fill_in_addresses only assigns to CPU 0 and fill_in_addresses only
runs on some CPU. So I guess the stagger handling could be just
removed because it's useless.

-Andi

-- 
ak@linux.intel.com
