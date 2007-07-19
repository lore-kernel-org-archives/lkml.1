Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbXGSLlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbXGSLlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbXGSLlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:41:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44493 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbXGSLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:41:05 -0400
Date: Thu, 19 Jul 2007 13:41:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jacob A <jacoba51-tmp@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
In-Reply-To: <581196.34917.qm@web57713.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0707191339090.30033@fbirervta.pbzchgretzou.qr>
References: <581196.34917.qm@web57713.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 19 2007 02:01, Jacob A wrote:
>
> How can a device driver go over the  list of all the files that are open on a
> specific inode instance?

pseudo-code:

task_list_lock;
for each process; do
	lock_fdtable;
	for each filedescriptor; do
		do_something(fd->file_ptr);
	unlock_fdtable;
task_list_unlock;


Though, you really don't want to do that.



	Jan
-- 
