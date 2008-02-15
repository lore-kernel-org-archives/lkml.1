Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbYBOJLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbYBOJLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYBOJKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:10:41 -0500
Received: from smtp.nokia.com ([192.100.122.233]:27353 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYBOJKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:10:36 -0500
Subject: RE: Abnormal behavior with JFFS2 on latest kernel
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: kmpark@infradead.org
Cc: "'linux-mtd'" <linux-mtd@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <005601c86fb1$7c79f100$1fa9580a@swcenter.sec.samsung.co.kr>
References: <004601c86fa2$201a78d0$1fa9580a@swcenter.sec.samsung.co.kr>
	 <1203065647.23414.6.camel@sauron>
	 <005601c86fb1$7c79f100$1fa9580a@swcenter.sec.samsung.co.kr>
Content-Type: text/plain; charset=utf-8
Date: Fri, 15 Feb 2008 11:08:58 +0200
Message-Id: <1203066538.23414.11.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Feb 2008 09:10:12.0194 (UTC) FILETIME=[91DA8C20:01C86FB2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 18:02 +0900, Kyungmin Park wrote:
> > On Fri, 2008-02-15 at 16:12 +0900, Kyungmin Park wrote:
> > > I got following messages.
> > > INFO: task pdflush:56 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > >
> > > What are the meanings?
> > > Too mush running GC in JFFS2 or others?
> > 
> > Hi Kyungmin,
> > 
> > did not look at this, but off the top of my head this might be related
> > to the latest VFS changes (write_begin()/write_end() instead of
> > prepare_write()/commit_write()). Just a hint where you might try to
> > look.
> > 
> 
> Then can I use the ubifs? I mean ubifs is already changed for latest VFS changes.
> Now I just want to test new driver with latest kernel.

No, in opposite, we have not changed it yet. The old calls were not
removed from VFS and will be kept there for few releases. So we still
use them - this helps to use the same UBIFS sources for older kernels.
But later we'll switch to newer calls which are in fact much better for
UBIFS then the old ones.

But yes, you of course can use UBIFS.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

