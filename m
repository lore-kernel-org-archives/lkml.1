Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYBHIJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYBHIJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYBHIJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:09:26 -0500
Received: from sacred.ru ([62.205.161.221]:59976 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYBHIJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:09:26 -0500
Message-ID: <47AC0E25.1060603@openvz.org>
Date: Fri, 08 Feb 2008 11:09:09 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][DOCUMENTATION] Minimal controller code for a quick start
References: <47AB25AD.30400@openvz.org> <6599ad830802071245r321efddat89a17b091cb5db4b@mail.gmail.com>
In-Reply-To: <6599ad830802071245r321efddat89a17b091cb5db4b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 08 Feb 2008 11:08:57 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Feb 7, 2008 7:37 AM, Pavel Emelyanov <xemul@openvz.org> wrote:
>> The Documentation/cgroups.txt file contains the info on how
>> to write some controller for cgroups subsystem, but even with
>> this, one need to write quite a lot of code before developing
>> the core (or copy-n-paste it from some other place).
> 
> Good idea.
> 
>> +
>> +static ssize_t foo_bar_read(struct cgroup *cg, struct cftype *cft,
>> +               struct file *file, char __user *userbuf,
>> +               size_t nbytes, loff_t *ppos)
>> +{
>> +       struct foo_cgroup *foo;
>> +
>> +       foo = foo_from_cgroup(cg);
>> +
>> +       /*
>> +        * produce some output
>> +        */
>> +
>> +       return nbytes;
>> +}
>> +
>> +static ssize_t foo_bar_write(struct cgroup *cg, struct cftype *cft,
>> +               struct file *file, const char __user *userbuf,
>> +               size_t nbytes, loff_t *ppos)
>> +{
>> +       struct foo_cgroup *foo;
>> +
>> +       foo = foo_from_cgroup(cg);
>> +
>> +       /*
>> +        * read and tune the foo
>> +        */
>> +
>> +       return nbytes;
>> +}
>> +
>> +static struct cftype foo_files[] = {
>> +       {
>> +               .name = "bar",
>> +               .read = foo_bar_read,
>> +               .write = foo_bar_write,
>> +       },
>> +};
> 
> Can you structure this example so as to encourage people to use the
> more formatted read/write routines, such as read_int64 and
> write_int64?

And one more for ->read_strategy hints :) Well, I thought that
it should be the _minimal_ controller.

>> +
>> +static struct cgroup_subsys_state *foo_create(struct cgroup_subsys *cs,
>> +               struct cgroup *cg)
>> +{
>> +       struct foo_cgroup *foo;
>> +
> 
> Maybe add a comment here that mentions that if your cgroup needs very
> early initialization, you can check for cg->parent being NULL, and
> return a statically-constructed structure here. (And set
> foo_subsys.early_init = 1)

Yet again - this is rather a special feature, that your controller
needs an early initialization - for a very minimal one this is not
required.

Maybe we can have two examples? One is the minimal one and the other
is an advanced one with ->attach callbacks, etc?

> Paul
> 

