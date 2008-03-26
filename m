Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYCZTBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYCZTBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbYCZTA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:00:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYCZTA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:00:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fxdzZ4MD4wvPXXW50+gyC/2tDaSODzTOBgr2izlgn7qCex0B9lKC+5BjdtSSvnUQ8
	nCFsoPBYl1HsBcsUWcBGw==
Message-ID: <6599ad830803261200w5c5749fcx6211f06d5d91c1c9@mail.gmail.com>
Date: Wed, 26 Mar 2008 12:00:45 -0700
From: "Paul Menage" <menage@google.com>
To: "Balaji Rao" <balajirrao@gmail.com>
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
Cc: linux-kernel@vger.kernel.org, balbir@in.ibm.com, containers@lists.osdl.org,
       dhaval@linux.vnet.ibm.com
In-Reply-To: <200803262348.45219.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803262348.45219.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 11:18 AM, Balaji Rao <balajirrao@gmail.com> wrote:
>  +
>  +static s64 cpu_cgroup_read_stat(struct cpu_cgroup_stat *stat,
>  +               enum cpu_cgroup_stat_index idx)
>  +{
>  +       int cpu;
>  +       s64 ret = 0;
>  +       for_each_possible_cpu(cpu)
>  +               ret += stat->cpustat[cpu].count[idx];

On a 32-bit architecture I think this could race with a non-atomic
update that crosses a 32-bit boundary and get a corrupted result.

Paul
