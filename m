Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXGVNH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXGVNH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 09:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbXGVNHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 09:07:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57510 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXGVNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 09:07:48 -0400
Date: Sun, 22 Jul 2007 15:07:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jacob A <jacoba51-tmp@yahoo.com>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
In-Reply-To: <333685.87286.qm@web57707.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0707221506090.15705@fbirervta.pbzchgretzou.qr>
References: <333685.87286.qm@web57707.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22 2007 05:45, Jacob A wrote:
>
>Ah, yes, this was my intention, to keep the state in filp->private_data.
>But then at a timer routine I wanted to go over all the filps associated with the device
>and check/modify the state. That's why I needed the open files list.

No. For each private_data that you allocate, create a linked list
that also has them. In other words:


struct mystuff {
	struct list_head list;
	int other_fluff;
};

int mydriver_open()
{
	struct mystuff *pd = kmalloc(...);
	filp->private_data = pd;
	list_add(&pd->list);
}

int mydriver_close()
{
	struct mystuff *pd = filp->private_data;
	list_del(&pd->list);
	free(pd);
}

Simple as that. *Of course* this requires that the file descriptor remains
open. But that should not be a problem, would it?


    Jan
-- 



>

    Jan
-- 



>

	Jan
-- 
