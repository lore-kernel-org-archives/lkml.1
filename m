Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYCQB4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYCQB4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYCQB4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:56:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYCQB4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:56:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Kp4jVGpAINO6mDRy2rozi5lyaQH1/r4p770AZZh1N0dYezzu2p4uvOnQd1vSnUBjn
	ac76p2vXw0rBNaIBoET6w==
Message-ID: <6599ad830803161855y1ceb8aa8t2f486434b521bd81@mail.gmail.com>
Date: Mon, 17 Mar 2008 09:55:59 +0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47DDCE5E.9020104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
	 <47DDCE5E.9020104@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 9:50 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  I am yet to measure the performance overhead of the accounting checks. I'll try
>  and get started on that today. I did not consider making it a separate system,
>  because I suspect that anybody wanting memory control would also want address
>  space control (for the advantages listed in the documentation).

I'm a counter-example to your suspicion :-)

Trying to control virtual address space is a complete nightmare in the
presence of anything that uses large sparsely-populated mappings
(mmaps of large files, or large sparse heaps such as the JVM uses.)

If we want to control the effect of swapping, the right way to do it
is to control disk I/O, and ensure that the swapping is accounted to
that. Or simply just not give apps much swap space.

Paul
