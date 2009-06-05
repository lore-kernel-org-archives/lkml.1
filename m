Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZFEUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZFEUV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZFEUVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:21:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbZFEUVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:21:19 -0400
Date: Fri, 5 Jun 2009 13:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: nishimura@mxp.nes.nec.co.jp
Cc: d-nishimura@mtf.biglobe.ne.jp, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com
Subject: Re: [PATCH mmotm] memcg: add interface to reset limits
Message-Id: <20090605132031.02f79021.akpm@linux-foundation.org>
In-Reply-To: <20090605222245.6920061a.d-nishimura@mtf.biglobe.ne.jp>
References: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp>
	<20090603114908.52c3aed5.nishimura@mxp.nes.nec.co.jp>
	<4A26072B.8040207@cn.fujitsu.com>
	<20090603144347.81ec2ce1.nishimura@mxp.nes.nec.co.jp>
	<20090605222245.6920061a.d-nishimura@mtf.biglobe.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 22:22:45 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> We don't have interface to reset mem.limit or memsw.limit now.
> 
> This patch allows to reset mem.limit or memsw.limit when they are
> being set to -1.
> 
> ...
>
> @@ -133,6 +133,16 @@ int res_counter_memparse_write_strategy(const char *buf,
>  					unsigned long long *res)
>  {
>  	char *end;
> +
> +	/* return RESOURCE_MAX(unlimited) if "-1" is specified */
> +	if (*buf == '-') {
> +		*res = simple_strtoull(buf + 1, &end, 10);
> +		if (*res != 1 || *end != '\0')
> +			return -EINVAL;
> +		*res = RESOURCE_MAX;
> +		return 0;
> +	}

The test for (*end != '\0') would be unneeded if strict_strtoull() had
been used.


> +
>  	/* FIXME - make memparse() take const char* args */
>  	*res = memparse((char *)buf, &end);
>  	if (*end != '\0')
