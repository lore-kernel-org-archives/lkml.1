Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXFWL61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXFWL61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFWL6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:58:20 -0400
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:32015 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbXFWL6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:58:19 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2007 07:58:19 EDT
Date: Sat, 23 Jun 2007 13:51:22 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 3/4] fbdev: uvesafb driver
Message-ID: <20070623115122.GI4096@aon.at>
References: <20070623105243.GD12623@spock.one.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623105243.GD12623@spock.one.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 12:52:43PM +0200, Michal Januszewski wrote:

>+static void uvesafb_cn_callback(void *data)
>+{
>+	struct cn_msg *msg = (struct cn_msg *)data;
>+	struct uvesafb_task *utask = (struct uvesafb_task *)msg->data;
>+	struct uvesafb_ktask *task;
>+
>+	if (msg->seq >= UVESAFB_TASKS_MAX)
>+		return;
>+
>+	task = uvfb_tasks[msg->seq];
>+
>+	if (!task || msg->ack != task->ack)
>+		return;

You need utask only here, so could spare setting it before the
checking above.
>+
>+	memcpy(&task->t, utask, sizeof(struct uvesafb_task));
>+
>+	if (task->t.buf_len && task->buf)
>+		memcpy(task->buf, ((u8*)utask) + sizeof(struct uvesafb_task),
>+						task->t.buf_len);
>+
>+	complete(task->done);
>+	return;
>+}
