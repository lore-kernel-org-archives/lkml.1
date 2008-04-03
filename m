Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYDCLno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYDCLno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYDCLnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:43:20 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44975 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754254AbYDCLnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:43:19 -0400
Date: Thu, 3 Apr 2008 20:41:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, geert@linux-m68k.org, ralf@linux-mips.org,
       kyle@parisc-linux.org, paulus@samba.org, schwidefsky@de.ibm.com,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 18/22] sh: Use generic show_mem()
Message-ID: <20080403114124.GA25523@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
	hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
	dhowells@redhat.com, ysato@users.sf.net, takata@linux-m32r.org,
	geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
	paulus@samba.org, schwidefsky@de.ibm.com, jdike@addtoit.com,
	miles@gnu.org, chris@zankel.net, rmk@arm.linux.org.uk,
	tony.luck@intel.com
References: <12071688283927-git-send-email-hannes@saeurebad.de> <12071690311447-git-send-email-hannes@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12071690311447-git-send-email-hannes@saeurebad.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:40:24PM +0200, Johannes Weiner wrote:
> -	printk(KERN_INFO "Total of %ld pages in page table cache\n",
> -	       quicklist_total_size());
> -}
> -

NACK. The quicklists are also absent from the generic implementation.
Doing things generically is nice and all, but please do not go around
removing all of the different implementations and consolidating on the
simplest point of commonality you could come up with. Either combine
everything in to a generic show_mem() that doesn't sacrifice
functionality, or only convert the platforms that are identical.
