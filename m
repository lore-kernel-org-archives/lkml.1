Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYDWM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYDWM6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYDWM6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:58:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:60313 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYDWM6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TH/MLpwpeMNEFN+xZw3HE1M/ZwKon9009R0tHYCxe6DagU1E8rsD67slxppDU3o+SJTLLV4X9cgy2TBsjCSRBFsW71VTLIftuI4VJ82Rs2PncFhFRjVgKNSryhn7JqrIFENyGW9aG6uN7pSb3CJppimutRW4n+HVN+Efhp3Ng6g=
Message-ID: <36ca99e90804230558y7ad26b78t1375a67d85edd286@mail.gmail.com>
Date: Wed, 23 Apr 2008 14:58:21 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] drivers/base/cpu.c: make code static
Cc: "Mike Travis" <travis@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080423095233.GL28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080423095233.GL28933@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 11:52 AM, Adrian Bunk <bunk@kernel.org> wrote:
> This patch makes the following needlessly global code static:
>  - attr_online_map
>  - attr_possible_map
>  - attr_present_map
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>  ---
>  8ab09fe4313384faa5e3577d99845cedccb245bc diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>  index 6fe4174..da6f4ae 100644
>  --- a/drivers/base/cpu.c
>  +++ b/drivers/base/cpu.c
>  @@ -119,7 +119,7 @@ static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)     \
>   {                                                                      \
>         return print_cpus_map(buf, &cpu_##type##_map);                  \
>   }                                                                      \
>  -struct sysdev_class_attribute attr_##type##_map =                      \
>  +static struct sysdev_class_attribute attr_##type##_map =               \
>         _SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
>
>   print_cpus_func(online);
I think the cpu_state_attr array a few lines down should be static too.

Bert
