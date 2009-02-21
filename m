Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZBUSUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZBUSUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 13:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZBUSUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 13:20:04 -0500
Received: from ms.avg.com ([193.85.188.248]:24879 "EHLO ms.grisoft.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZBUSUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 13:20:03 -0500
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Feb 2009 13:20:03 EST
Date: Sat, 21 Feb 2009 19:11:24 +0100
From: Frantisek Hrbata <frantisek.hrbata@avg.com>
To: John Ogness <dazukocode@ogness.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "malware-list@lists.printk.net" <malware-list@lists.printk.net>
Subject: Re: [malware-list] [PATCHv2 3/5] VFS: DazukoFS, stackable-fs,	file
 access control
Message-ID: <20090221191124.238743a4@humpdell>
In-Reply-To: <86skmvfhx6.fsf_-_@johno.fn.ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<86skmvfhx6.fsf_-_@johno.fn.ogness.net>
Organization: AVG Technologies
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 20:18:29 +0100
John Ogness <dazukocode@ogness.net> wrote:

> +/**
> + * dazukofs_add_group - add a new group
> + * @name: the name of the group to add
> + *
> + * Description: This function is called by the device layer to add a new
> + * group. It returns success if the group has been successfully created
> + * or if the group already exists.
> + *
> + * Returns 0 on success.
> + */
> +int dazukofs_add_group(const char *name)
> +{
> +       int ret = 0;
> +       int already_exists;
> +       int available_id = 0;
> +       struct dazukofs_group *grp;
> +
> +       write_lock(&group_count_rwlock);
> +
> +       mutex_lock(&work_mutex);

Hi,

you cannot hold spinlock and try to acquire mutex.

write_lock() -> preempt_disable() vs mutex_lock -> schedule()

-FH
