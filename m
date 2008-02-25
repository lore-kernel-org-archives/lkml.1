Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYBYQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYBYQRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYBYQRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:17:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:61659 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYBYQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:17:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=IpXPtAoopViyiCoOMT7DNq00QhflKtdNo9Lm2B/uoosZrFUzIsd+kF/sCWUsfYv9A
	Wg0Xf6NJFrI4zoMv1DOiQ==
Message-ID: <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com>
Date: Mon, 25 Feb 2008 08:16:40 -0800
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Memory Resource Controller Add Boot Option
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080225115550.23920.43199.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080225115509.23920.66231.sendpatchset@localhost.localdomain>
	 <20080225115550.23920.43199.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 3:55 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
>  A boot option for the memory controller was discussed on lkml. It is a good
>  idea to add it, since it saves memory for people who want to turn off the
>  memory controller.
>
>  By default the option is on for the following two reasons
>
>  1. It provides compatibility with the current scheme where the memory
>    controller turns on if the config option is enabled
>  2. It allows for wider testing of the memory controller, once the config
>    option is enabled
>
>  We still allow the create, destroy callbacks to succeed, since they are
>  not aware of boot options. We do not populate the directory will
>  memory resource controller specific files.

Would it make more sense to have a generic cgroups boot option for this?

Something like cgroup_disable=xxx, which would be parsed by cgroups
and would cause:

- a "disabled" flag to be set to true in the subsys object (you could
use this in place of the mem_cgroup_on flag)

- prevent the disabled cgroup from being bound to any mounted
hierarchy (so it would be ignored in a mount with no subsystem
options, and a mount with options that specifically pick that
subsystem would give an error)

Paul
