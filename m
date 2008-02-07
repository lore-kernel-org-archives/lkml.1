Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbYBGUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbYBGUpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYBGUpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:45:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38204 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYBGUpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:45:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VKehuN9Hgq3ncQqsglKphCQeu3gacV2fV6LXNmWR3KQsp/4RbIdF+hHgxS3KBdj+V
	6wLQRoTaeEVjsMHXGVahg==
Message-ID: <6599ad830802071245r321efddat89a17b091cb5db4b@mail.gmail.com>
Date: Thu, 7 Feb 2008 12:45:18 -0800
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH][DOCUMENTATION] Minimal controller code for a quick start
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47AB25AD.30400@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB25AD.30400@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 7:37 AM, Pavel Emelyanov <xemul@openvz.org> wrote:
> The Documentation/cgroups.txt file contains the info on how
> to write some controller for cgroups subsystem, but even with
> this, one need to write quite a lot of code before developing
> the core (or copy-n-paste it from some other place).

Good idea.

> +
> +static ssize_t foo_bar_read(struct cgroup *cg, struct cftype *cft,
> +               struct file *file, char __user *userbuf,
> +               size_t nbytes, loff_t *ppos)
> +{
> +       struct foo_cgroup *foo;
> +
> +       foo = foo_from_cgroup(cg);
> +
> +       /*
> +        * produce some output
> +        */
> +
> +       return nbytes;
> +}
> +
> +static ssize_t foo_bar_write(struct cgroup *cg, struct cftype *cft,
> +               struct file *file, const char __user *userbuf,
> +               size_t nbytes, loff_t *ppos)
> +{
> +       struct foo_cgroup *foo;
> +
> +       foo = foo_from_cgroup(cg);
> +
> +       /*
> +        * read and tune the foo
> +        */
> +
> +       return nbytes;
> +}
> +
> +static struct cftype foo_files[] = {
> +       {
> +               .name = "bar",
> +               .read = foo_bar_read,
> +               .write = foo_bar_write,
> +       },
> +};

Can you structure this example so as to encourage people to use the
more formatted read/write routines, such as read_int64 and
write_int64?

> +
> +static struct cgroup_subsys_state *foo_create(struct cgroup_subsys *cs,
> +               struct cgroup *cg)
> +{
> +       struct foo_cgroup *foo;
> +

Maybe add a comment here that mentions that if your cgroup needs very
early initialization, you can check for cg->parent being NULL, and
return a statically-constructed structure here. (And set
foo_subsys.early_init = 1)

Paul
