Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbXH0Tf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbXH0Tf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbXH0TfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:35:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44644 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbXH0TfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:35:20 -0400
Date: Mon, 27 Aug 2007 20:35:10 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Dean Nelson <dcn@sgi.com>
Cc: akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com,
       jes@sgi.com
Subject: Re: [PATCH 1/4] export __put_task_struct for XPMEM
Message-ID: <20070827193510.GJ21089@ftp.linux.org.uk>
References: <20070827155622.GA25589@sgi.com> <20070827155933.GB25589@sgi.com> <20070827161327.GG21089@ftp.linux.org.uk> <20070827181056.GA30176@sgi.com> <20070827181544.GH21089@ftp.linux.org.uk> <20070827191906.GB30176@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827191906.GB30176@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 02:19:06PM -0500, Dean Nelson wrote:

> No operations can be done once it's closed, only while it's opened.

What the hell do you mean, can't be done?

	fd = open(...);
	fp = popen("/bin/date", "r");
	/* read from fp */
	fclose(fp);
	do operations on fd

And you've got yourself
	open
	fork duplicating descriptor
	exit closing that duplicate
	IO on original, after call of flush
