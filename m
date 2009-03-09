Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZCIUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZCIUnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZCIUmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:42:54 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:51447 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbZCIUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zi7FlVQaBxWx2W115Vf7xXBTQUBc64fg9nyLYKR6Q2cOwEynLDyql+7RrbDHJsPWJt
         UBFN6BrIgFQpuSKRMuTQ0wsTlKZIpi/fzc508Exkt82C1p6G9A3a+01bYtkHd9i0ZvhF
         fS5Ma2i9Yi9iFy+JkGdQkcqiO01EA2VeALCNA=
Message-ID: <49B57F45.7040104@gmail.com>
Date: Mon, 09 Mar 2009 21:42:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linux-kernel@vger.kernel.org, rdreier@cisco.com, peterz@infradead.org,
       will.newton@gmail.com
Subject: Re: [PATCH v3] add function spin_event_timeout()
References: <1236630740-22024-1-git-send-email-timur@freescale.com>
In-Reply-To: <1236630740-22024-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.3.2009 21:32, Timur Tabi wrote:
> +#define spin_event_timeout(condition, timeout)				\
> +({									\
> +	int __timeout = timeout;					\
> +	while (!(condition)&&  --__timeout) {				\
> +		udelay(1);						\
> +		cpu_relax();						\

So you don't need cpu_relax anymore...

And I would make timeout UL like delay functions.
