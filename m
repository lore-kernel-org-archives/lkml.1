Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYGAKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYGAKwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGAKvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:51:44 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:11861 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYGAKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:51:42 -0400
Date: Tue, 1 Jul 2008 12:51:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kobjects: Transmit return value of
 kobject_uevent_env() to caller
Message-ID: <20080701125124.34817629@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <48620B15.9060608@cn.fujitsu.com>
References: <4860B75A.1050307@cn.fujitsu.com>
	<20080624162448.4b1e3d87@gondolin.boeblingen.de.ibm.com>
	<486198F1.6000601@cn.fujitsu.com>
	<48620B15.9060608@cn.fujitsu.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 17:08:37 +0800,
Wang Chen <wangchen@cn.fujitsu.com> wrote:

> It's depended on how important sending uevent is.
> If the sysfs operation succeeds, but user-space don't
> get the notification. Is it ok?

Given that (a) there may be no listener, (b) sending via netlink may
succeed but calling uevent_helper may fail (highly unlikely the way
modern distros are set up, though), and (c) you would have to audit a
myriad places that don't check for the return code of kobject_uevent()
today as well, it looks like the best way is to simply add some
pr_debug()s to kobject_uevent_env() where something fails.
