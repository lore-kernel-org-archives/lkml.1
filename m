Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXEVOwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXEVOwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXEVOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:51:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49906 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbXEVOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:51:54 -0400
Date: Tue, 22 May 2007 09:51:25 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Delay writing 0's after llseek until write
Message-ID: <20070522145124.GA3616@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070521230021.GD3621@us.ibm.com> <20070521210708.67d365dc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521210708.67d365dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 09:07:08PM -0700, Andrew Morton wrote:
> On Mon, 21 May 2007 18:00:21 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
> > Delay writing 0's out in eCryptfs after a seek past the end of the
> > file until data is actually written.
> 
> a) why?

http://www.opengroup.org/onlinepubs/009695399/functions/lseek.html

``The lseek() function shall not, by itself, extend the size of a
file.''

> b) what is the impact upon a user of them not having this patch?

Applications that lseek() past the end of the file without writing
will experience unexpected behavior.

Mike
