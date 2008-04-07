Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYDGU6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYDGU6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYDGU55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:57:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:24779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYDGU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:57:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,618,1199692800"; 
   d="scan'208";a="313526834"
Message-ID: <47FA8A69.6080402@linux.intel.com>
Date: Mon, 07 Apr 2008 13:56:09 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>,
       Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071123.27411.jbarnes@virtuousgeek.org> <47FA7B58.6040907@tungstengraphics.com> <200804071259.19743.jbarnes@virtuousgeek.org>
In-Reply-To: <200804071259.19743.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> 
> Yeah, they're ioremapped now, but that's a problem since with the PAT patches 
> they'll be mapped hard UC (right now it just happens to work).
> 
clearly this needs to use ioremap_wc(), I was assuming nothing else....
(code mapping things uncached and then frobbing the MTRR's underneath really shouldn't
be allowed to live from 2.6.26 and forward. Esp for the 3D drivers we KNOW that we
want _wc so that is a clear case of just fixing the code to do the right thing)
