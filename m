Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZKWPci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZKWPci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZKWPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:32:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:41852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZKWPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:32:37 -0500
Subject: Re: [PATCH v2 04/12] Add "handle page fault" PV helper.
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com
In-Reply-To: <1258985167-29178-5-git-send-email-gleb@redhat.com>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>
	 <1258985167-29178-5-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 16:32:30 +0100
Message-ID: <1258990350.4531.589.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 16:05 +0200, Gleb Natapov wrote:

> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f4cee90..14707dc 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -952,6 +952,9 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	int write;
>  	int fault;
>  
> +	if (arch_handle_page_fault(regs, error_code))
> +		return;
> +
>  	tsk = current;
>  	mm = tsk->mm;
>  

That's a bit daft, the pagefault handler is already arch specific, so
you're placing an arch_ hook into arch code, that doesn't make sense.

