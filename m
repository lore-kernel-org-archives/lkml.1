Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0BJWUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:20:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56180 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639Ab0BJWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:20:17 -0500
Date: Wed, 10 Feb 2010 22:18:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: Lubos Lunak <l.lunak@suse.cz>, David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
Message-ID: <20100210221847.5d7bb3cb@lxorguk.ukuu.org.uk>
In-Reply-To: <4B7320BF.2020800@redhat.com>
References: <201002012302.37380.l.lunak@suse.cz>
	<4B6B4500.3010603@redhat.com>
	<alpine.DEB.2.00.1002041410300.16391@chino.kir.corp.google.com>
	<201002102154.43231.l.lunak@suse.cz>
	<4B7320BF.2020800@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Killing the system daemon *is* a DoS.
> 
> It would stop eg. the database or the web server, which is
> generally the main task of systems that run a database or
> a web server.

One of the problems with picking on tasks that fork a lot is that
describes apache perfectly. So a high loaded apache will get shot over a
rapid memory eating cgi script.

Any heuristic is going to be iffy - but that isn't IMHO a good one to
work from. If anything "who allocated lots of RAM recently" may be a
better guide but we don't keep stats for that.

Alan
