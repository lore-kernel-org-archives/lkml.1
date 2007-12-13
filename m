Return-Path: <linux-kernel-owner+w=401wt.eu-S1765787AbXLMXw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765787AbXLMXw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXLMXwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:52:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbXLMXwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:52:46 -0500
Date: Thu, 13 Dec 2007 18:52:42 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print taint info in more places.
Message-ID: <20071213235242.GA12755@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071213224927.GA18639@redhat.com> <p73y7byfb0h.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73y7byfb0h.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 12:08:46AM +0100, Andi Kleen wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > >  #define WARN_ON(condition) ({						\
 > >  	int __ret_warn_on = !!(condition);				\
 > >  	if (unlikely(__ret_warn_on)) {					\
 > > -		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
 > > -			__LINE__, __FUNCTION__);			\
 > > +		printk(KERN_ERR "WARNING: at %s:%d %s() (%s)\n",	\
 > > +			 __FILE__, __LINE__, __FUNCTION__,		\
 > > +			 print_tainted());				\
 > >  		dump_stack();						\
 > 
 > Have you checked how this affects code size? It might be worth it 
 > now to do a out of line helper.

64 bit debug build of the fedora kernel (which should be worse 
 case for WARN_ONs etc).

         text     data     bss     dec     hex filename
before   3833875  834267  631136 5299278  50dc4e vmlinux
after    3837054  834267  631136 5302457  50e8b9 vmlinux

Some of that growth is the addition of the missing KERN_ERR,
but yeah, it grows a little bit.

	Dave

-- 
http://www.codemonkey.org.uk
