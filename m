Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYGQGPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYGQGPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbYGQGOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:14:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60744 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbYGQGOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:14:52 -0400
Subject: Re: KVM overflows the stack
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <487EDE26.8040201@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>
	 <1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>
	 <487EDE26.8040201@qumranet.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 23:14:48 -0700
Message-Id: <1216275288.11664.13.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 08:52 +0300, Avi Kivity wrote:
> Dave Hansen wrote:
> > Avi, how would you like this fixed?  I'd be happy to prepare some
> > patches.  Do you have a particular approach that you think we should
> > use?  Just make the big objects dynamically allocated?
> >   
> 
> Yes, things like kvm_lapic_state are way too big to be on the stack.  
> There's an additional problem here, that apparently your gcc (which 
> version?) doesn't fold objects in a switch statement into the same stack 
> slot:

$ gcc -v
gcc version 3.4.6 (Ubuntu 3.4.6-6ubuntu5)

> switch (...) {
>     case x: {
>          struct medium a;
>          ...
>     }
>     case y:
>           struct medium b;
>           ...
>     }
> };
> 
> These could be solved either by stack allocation, or by moving into 
> functions marked noinline.  Whichever is easier.

Did you mean dynamic allocation? :)

-- Dave

