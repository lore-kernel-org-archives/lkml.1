Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbXKTCuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbXKTCuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXKTCt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:49:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41876 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbXKTCt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:49:56 -0500
Date: Mon, 19 Nov 2007 18:49:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 45/45] Modules: Hack to handle symbols that have a zero
 value
In-Reply-To: <20071120022007.GA16899@Krystal>
Message-ID: <Pine.LNX.4.64.0711191849180.21479@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011342.426906810@sgi.com>
 <20071120022007.GA16899@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Mathieu Desnoyers wrote:

> * clameter@sgi.com (clameter@sgi.com) wrote:
> > The module subsystem cannot handle symbols that are zero. It prints out
> > a message that these symbols are unresolved. Define a constant
> > 
> > UNRESOLVED
> > 
> > that is used to hold the value used for unresolved symbols. Set it to 1
> > (its hopefully unlikely that a symbol will have the value 1). This is necessary
> > so that the pda variable which is placed at offset 0 of the per cpu
> > segment is handled correctly.
> > 
> 
> Wouldn't it be better to simply return a standard ERR_PTR(-ENO....) ?

Good idea. But can you guarantee that this wont clash with an address?

