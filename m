Return-Path: <linux-kernel-owner+w=401wt.eu-S936479AbXGTVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936479AbXGTVlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXGTVlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:41:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:19679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbXGTVla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:41:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iU7K4q/xeuhnjWMAv5qVyyCpB5PtMeILI+hIBVvWsKXiAraCWDy4GLsQLCJZsuFye
	LuCmeiJJCXsj5rmRWw1DA==
Message-ID: <6599ad830707201441q65c8efc2kecd99d6d8094672@mail.gmail.com>
Date: Fri, 20 Jul 2007 14:41:22 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm PATCH 8/8] Add switch to control what type of pages to limit (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Eric W Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070720082528.20752.16398.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
	 <20070720082528.20752.16398.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> -static struct mem_container init_mem_container;
> +static ssize_t mem_control_type_read(struct container *cont,
> +                               struct cftype *cft,
> +                               struct file *file, char __user *userbuf,
> +                               size_t nbytes, loff_t *ppos)
> +{
> +       unsigned long val;
> +       char buf[64], *s;
> +       struct mem_container *mem;
> +
> +       mem = mem_container_from_cont(cont);
> +       s = buf;
> +       val = mem->control_type;
> +       s += sprintf(s, "%lu\n", val);
> +       return simple_read_from_buffer((void __user *)userbuf, nbytes,
> +                       ppos, buf, s - buf);
> +}

This could just use the read_uint64() hook and be something like

static u64 mem_container_control_type_read(struct container *cont,
struct cftype *cft)
{
  return mem_container_from_cont(cont)->control_type;
}

Paul
