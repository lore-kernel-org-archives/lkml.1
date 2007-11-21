Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbXKUAKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbXKUAKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbXKUAKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:10:46 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755453AbXKUAKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:10:46 -0500
Date: Tue, 20 Nov 2007 16:10:45 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <Pine.LNX.4.64.0711201325130.27539@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711201607460.29220@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de>
 <Pine.LNX.4.64.0711201228180.26745@schroedinger.engr.sgi.com>
 <200711202159.36377.ak@suse.de> <Pine.LNX.4.64.0711201325130.27539@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Christoph Lameter wrote:

> 32bit sign extension for what? Absolute data references? The addressing 
> that I have seen was IP relative. Thus I thought that the kernel could be 
> moved lower.

Argh. This is all depending on a special gcc option to compile the 
kernel and that option limits the kernel to the upper 2GB. So I guess for 
CPU_PTR we need to explicitly load the address as a constant, use that as 
a base and then add the offset and the smp_id shifted to it in the 
instruction. The CPU_INC/DEC stuff using gs is not affected.


