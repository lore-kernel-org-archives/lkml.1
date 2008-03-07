Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbYCGJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbYCGJaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbYCGJ0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:26:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:4858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbYCGJZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:25:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qxFQtX++irN6SiCU0e9zCnnVWFPvnRfidpuHBE4dFiX+crWvBrV1KaKTX9w3v29RT
	RILP0dq7wPBENhwB6mziA==
Message-ID: <6599ad830803070125o1ebfd7d1r728cdadf726ecbe2@mail.gmail.com>
Date: Fri, 7 Mar 2008 01:25:51 -0800
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 12:57 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  This doesn't handle early_init subsystems (their "disabled" bit isn't
>  set be,

I think you meant something like

(their "disabled" bit isn't set before their initial "create" call is made)

>  +static int __init cgroup_disable(char *str)
>  +{
>  +       int i;
>  +
>  +       while (*str) {
>  +               for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  +                       struct cgroup_subsys *ss = subsys[i];
>  +
>  +                       if (!strncmp(str, ss->name, strlen(ss->name))) {
>  +                               ss->disabled = 1;
>  +                               printk(KERN_INFO "Disabling %s control group"
>  +                                       " subsystem\n", ss->name);
>  +                               break;

Doesn't this mean that cgroup_disable=cpu will disable whichever comes
first out of cpuset, cpuacct or cpu in the subsystem list?

I suggest just sticking with the original simpler version that
required separate cgroup_disabled=foo options for each system that you
want to disable.

Paul
