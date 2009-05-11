Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZEKV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZEKV31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759638AbZEKV3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:29:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58116 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759634AbZEKV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:29:08 -0400
Date: Mon, 11 May 2009 22:26:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090511222608.61b99dad@lxorguk.ukuu.org.uk>
In-Reply-To: <4A0894A5.9000209@zytor.com>
References: <4A05269D.8000701@kernel.org>
	<4A0527CB.4020807@kernel.org>
	<20090511175312.GA27905@sgi.com>
	<alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
	<4A0894A5.9000209@zytor.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CPU [0-1] cannot be considered local in either node, since they are 
> further away from the memory than either, and furthermore, unlike either 
> of the memory nodes, they have no preference for memory from either of 
> the other two nodes (quite on the contrary; they would probably benefit 
> from drawing from both.)

Surely you should schedule based on the memory bandwidth at that point ?
Assuming the data collection overhead is acceptable. A long time ago
someone did a paper on a related topic (Scheduling by memory bandwidth on
the grounds that memory not CPU bandwidth was the resource most
constrained) and that demonstrated that for quite a few processors the
memory bandwidth data is cheaply available in the profiling registers.

Alan
