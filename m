Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYLLBOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYLLBOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 20:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbYLLBNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 20:13:55 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47955 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbYLLBNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 20:13:54 -0500
Date: Fri, 12 Dec 2008 10:12:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory 
 controller
Message-Id: <20081212101257.9be5436f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830812110905k4e32363fp671bf88e18fbf349@mail.gmail.com>
References: <20081210233654.563182000@menage.corp.google.com>
	<20081210234432.236302000@menage.corp.google.com>
	<20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com>
	<20081211100501.bf538f0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081211063307.GL3008@balbir.in.ibm.com>
	<20081211155323.957eb73c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830812110905k4e32363fp671bf88e18fbf349@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 09:05:47 -0800
Paul Menage <menage@google.com> wrote:

> On Wed, Dec 10, 2008 at 10:53 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > Could you write a document to explain what kind of nest of locks are allowed
> > before merging this ?
> 
> We should probably treat it similarly to the cpuset "callback_mutex".
> I.e. memory allocations are most likely forbidden when you're holding
> it.
> 
Hmm. Anyway, hierarchy mutex should not be aquired in deep stack of the kernel
calls. (and my patch will make memcg's hierarchy walk lockless.)

-Kame

