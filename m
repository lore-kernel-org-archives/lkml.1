Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZA0FJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZA0FJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZA0FJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:09:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35865 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZA0FJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:09:09 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: lirc@bartelmus.de (Christoph Bartelmus)
Subject: [PATCH] export get_task_comm()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AuEeLWHZjFB@christoph>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph>
Message-Id: <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 14:09:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> on 19 Jan 09 at 07:36, KOSAKI Motohiro wrote:
> >> is there any reason why get_task_comm() is not exported in fs/exec.c?
> 
> > In general, the only function of anybody necessarity explained is exported.
> > if you want to export get_task_comm(), you need to explain reasonable
> > reason.
> 
> It's nothing that important: just want to print the executable name to the  
> logs during error handling. get_task_comm() is the required accessor  
> function.
> 
> http://lirc.cvs.sourceforge.net/viewvc/lirc/lirc/drivers/lirc_dev/lirc_dev.c?revision=1.70&view=markup

To be honest, I don't use get_task_comm(). but I don't oppose your request.

==
Subject: [PATCH] export get_task_comm()

task::comm is good debugging information and driver developer want to
use this information easily.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/fs/exec.c
===================================================================
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -936,6 +936,7 @@ char *get_task_comm(char *buf, struct ta
 	task_unlock(tsk);
 	return buf;
 }
+EXPORT_SYMBOL_GPL(get_task_comm);
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {





