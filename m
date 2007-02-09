Return-Path: <linux-kernel-owner+w=401wt.eu-S2992439AbXBISPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992439AbXBISPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXBISPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:15:31 -0500
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:57536 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992439AbXBISPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:15:31 -0500
Date: Fri, 9 Feb 2007 13:15:28 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH 4 of 7]  lguest: Config and headers
In-Reply-To: <1171033741.2718.172.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702091304090.9927@d.namei>
References: <1171033146.2718.157.camel@localhost.localdomain> 
 <1171033383.2718.163.camel@localhost.localdomain> 
 <1171033436.2718.165.camel@localhost.localdomain> 
 <1171033484.2718.167.camel@localhost.localdomain>
 <1171033741.2718.172.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Rusty Russell wrote:

> +/* 64k ought to be enough for anybody! */
> +#define HYPERVISOR_MAP_ORDER 16
> +#define HYPERVISOR_PAGES ((1 << HYPERVISOR_MAP_ORDER)/PAGE_SIZE)

I think it'd be better to go back to defining HYPERVISOR_SIZE then derive 
the map order from that via get_order(), as it should be 4 instead of 16; 
and this code is now both implying PAGE_SIZE while also using it for 
calculations. 


- James
-- 
James Morris
<jmorris@namei.org>
