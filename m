Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYBPJzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYBPJzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYBPJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:54:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbYBPJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:54:50 -0500
Date: Sat, 16 Feb 2008 01:54:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com
Subject: Re: + bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch added
 to -mm tree
Message-Id: <20080216015442.e94dc0ca.akpm@linux-foundation.org>
In-Reply-To: <20080216.012741.243894500.davem@davemloft.net>
References: <200802160449.m1G4nX5V009024@imap1.linux-foundation.org>
	<20080216.012741.243894500.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 01:27:41 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: akpm@linux-foundation.org
> Date: Fri, 15 Feb 2008 20:49:33 -0800
> 
> > Subject: bluetooth: fix warning in net/bluetooth/hci_sysfs.c
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > net/bluetooth/hci_sysfs.c: In function 'del_conn':
> > net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value
> > 
> > Cc: Dave Young <hidave.darkstar@gmail.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Linus barfed when this exact patch got posted a few weeks
> ago, he said he considers just adding parenthesis to quiet
> this warning awful and explicit NULL test should be used.

-	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
+	while ((dev = device_find_child(&conn->dev, NULL, __match_tty))) {

hrm.

box:/usr/src/linux-2.6.25-rc2> grep -r 'while [(][(].*{$' . | wc -l               
1240
box:/usr/src/linux-2.6.25-rc2> grep -r 'while [(][(].*{$' . | grep -v NULL | wc -l
867

so two thirds of them presently don't bother testing for NULL.  It's a
pretty common idiom.

(adds the != NULL, sees that it reaches column 82, drops patch in disgust)
