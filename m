Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYCaIeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYCaIeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYCaIeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:34:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40372 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYCaIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:34:36 -0400
Date: Mon, 31 Mar 2008 10:38:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Message-ID: <20080331083816.GC29105@one.firstfloor.org>
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F098E8.1050605@tungstengraphics.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also I think we need to clarify the semantics of the c_p_a 
> functionality. Right now both AGP and DRM relies on c_p_a  doing an 
> explicit cache flush. Otherwise the data won't appear on the device side 
> of the aperture.

But surely not in cpa I hope ? Or are you saying you first write data
and then do cpa? If true that would be quite an abuse of CPA 
I would say and you should fix it ASAP.

> If we use self-snoop, the AGP and DRM drivers can't rely on this flush 
> being performed, and they have to do the flush themselves, and for 

They definitely should flush themselves if they want data to reach
the device. That is obviously required any time they reuse a page
too.

-Andi
