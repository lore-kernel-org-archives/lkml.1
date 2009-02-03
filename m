Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZBCPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZBCPIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZBCPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:08:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZBCPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:08:22 -0500
Date: Tue, 3 Feb 2009 16:08:16 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090203150816.GB20323@random.random>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130061714.GC31209@kroah.com> <20090202220856.GY20323@random.random> <20090203133811.47324d80.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203133811.47324d80.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 01:38:11PM +0900, KAMEZAWA Hiroyuki wrote:
> From above, FOLL_WRITE can be dropped and PageGUP() will not be set ?

Yeah, this was an implementation trouble!! If cow triggered, PG_gup
wasn't getting set as it should have.

The only remaining bit is to check hugetlb pages...
