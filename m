Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYJOC1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYJOC1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYJOC1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:27:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16902 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYJOC1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:27:36 -0400
X-IronPort-AV: E=Sophos;i="4.33,413,1220241600"; 
   d="scan'208";a="61145169"
Subject: Re: [PATCH 2/6] Blackfin Serial Driver: Add a debug function to
	serial driver.
From: gyang <graf.yang@analog.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>, alan@redhat.com,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20081014142701.72090868@lxorguk.ukuu.org.uk>
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
	 <1223891185-13924-3-git-send-email-cooloney@kernel.org>
	 <20081014142701.72090868@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=gbk
Date: Wed, 15 Oct 2008 10:23:41 +0800
Message-Id: <1224037421.6284.40.camel@dyang>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Oct 2008 02:27:23.0276 (UTC) FILETIME=[8E6F94C0:01C92E6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan,

We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
data cache flush function which will count it to a per-cpu counter.
If this serial function is called too early, the per-cpu data area have
not been initialized, this call will cause crash.
So we'd like to use barrier() instead of cpu_relax().

BRs,
Graf

在 2008-10-14二的 14:27 +0100，Alan Cox写道：
> > -		cpu_relax();
> > +		barrier();
> > +
> 
> Seems to be an odd unrelated change ?
