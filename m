Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYIBWqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYIBWqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYIBWqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:46:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbYIBWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:46:30 -0400
Date: Tue, 2 Sep 2008 15:46:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] /proc/mtrr I/O error
Message-Id: <20080902154620.314ad5c2.akpm@linux-foundation.org>
In-Reply-To: <20080829213824.GA2281@gherkin.frus.com>
References: <20080829213824.GA2281@gherkin.frus.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 16:38:24 -0500
Bob Tracy <rct@gherkin.frus.com> wrote:

> With 2.6.27-rc4 and possibly earlier kernels, I see the following:
> 
> $ cat /proc/mtrr
> cat: /proc/mtrr: Input/output error
> 
> Processor is an AMD K6-III/450.
> 

static int mtrr_open(struct inode *inode, struct file *file)
{
	if (!mtrr_if) 
		return -EIO;



Beats me.  Perhaps something broke in mtrr_bp_init().

It would be useful to know if 2.6.26 worked OK.

Thanks.
