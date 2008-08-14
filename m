Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYHNIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYHNIjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYHNIjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:39:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:42011 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYHNIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YUzz6RDweFvhO+P4HJiLQloQF2GqlUl4LpvpFasoavF0h1kwV99nbSTC6fuflGLELq
         EmBRuApD1zdiAEAgaGSwbkDma8vF3GWkD32NrRlicHYyjBm/i03Re+4TVEm7STOyZtgx
         UUelSZP0isxoQ3yFZDqfcNvMCMEdcpgE/lDOA=
Message-ID: <84144f020808140139v691e6590idd79995168af4e9e@mail.gmail.com>
Date: Thu, 14 Aug 2008 11:39:00 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [PATCH 2.6.27-rc3 26/29] mdb: export task_curr
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200808140614.m7E6EcDS006264@wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808140614.m7E6EcDS006264@wolfmountaingroup.com>
X-Google-Sender-Auth: 4fae3270686d34fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 9:14 AM,  <jmerkey@wolfmountaingroup.com> wrote:
> export the task_curr function to the module based kernel debugger to enable
> process back tracing and state display.
>
> Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)
>
> --- a/kernel/sched.c    2008-08-13 14:22:32.000000000 -0600
> +++ b/kernel/sched.c    2008-08-13 11:56:03.000000000 -0600
> @@ -1736,6 +1736,9 @@
>  {
>        return cpu_curr(task_cpu(p)) == p;
>  }
> +#if defined(CONFIG_MDB_MODULE)
> +EXPORT_SYMBOL_GPL(task_curr);
> +#endif

We usually don't export symbols conditionally, especially in core kernel code.
