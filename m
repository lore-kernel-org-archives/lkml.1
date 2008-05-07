Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYEGBjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYEGBjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYEGBjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:39:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbYEGBji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:39:38 -0400
Date: Tue, 6 May 2008 18:38:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506183841.e1771032.akpm@linux-foundation.org>
In-Reply-To: <48210101.1070205@google.com>
References: <48210101.1070205@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 18:08:17 -0700 Paul Menage <menage@google.com> wrote:

> -static int update_relax_domain_level(struct cpuset *cs, char *buf)
> +static int update_relax_domain_level(struct cpuset *cs, s64 val)
>  {
> -	int val = simple_strtol(buf, NULL, 10);
> -
> -	if (val < 0)
> +	if ((int)val < 0)
>  		val = -1;
>  

Are you sure about the typecast here?  If `val' has a value of say
0x0000_ffff_ffff_ffff then I assume the casted value will be negative, only
it wasn't?

