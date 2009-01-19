Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZASWTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZASWTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZASWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:18:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:58593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZASWSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:18:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,291,1231142400"; 
   d="scan'208";a="658390323"
Subject: Re: WARNING: at drivers/dma/dmaengine.c:352
	dma_issue_pending_all+0x77/0x15d()
From: Dan Williams <dan.j.williams@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1232402680.22432.5.camel@dwillia2-linux.ch.intel.com>
References: <20090119213106.GA9648@elte.hu>
	 <1232402680.22432.5.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 15:18:52 -0700
Message-Id: <1232403532.22432.14.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 15:04 -0700, Dan Williams wrote:
> On Mon, 2009-01-19 at 14:31 -0700, Ingo Molnar wrote:
> > FYI, i'm getting this on a testbox, on v2.6.29-rc2:
> 
> Thanks for the report.  I assume this is with CONFIG_DMA_ENGINE=n?
> dma_issue_pending_all should be a nop in that case.  I'll apply the
> following with your confirmation.
> 

Spoke too soon, the call to dma_issue_pending_all is protected by ifdef
CONFIG_NET_DMA.  Reading that counter without synchronizing with
dma_list_mutex is a problem.  I think I'll just remove the warnings for
now.

--
Dan

