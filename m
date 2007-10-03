Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXJCSur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXJCSur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXJCSuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:50:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43528 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXJCSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:50:39 -0400
Date: Wed, 3 Oct 2007 13:50:35 -0500
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Message-ID: <20071003185035.GS4338@austin.ibm.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <20070924123531.GC30855@shadowen.org> <20071002232819.GN4338@austin.ibm.com> <20071003002646.GD9814@bakeyournoodle.com> <1191371416.8073.1.camel@concordia> <20071003011909.GG9814@bakeyournoodle.com> <1191384586.8073.6.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191384586.8073.6.camel@concordia>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 02:09:46PM +1000, Michael Ellerman wrote:
> 
> Until we initialise what exactly?

Until we allocate the error log buffer. The original crash was 
for a null-pointer deref of the unallocated buffer. I just sent 
out a patch to fix this; its a bit simpler than the below.

In that email, I remarked:

Andy Whitcroft's crash was appearently due to firmware complaining
about lost power, (actually, lost power supply redundancy!), which
occurred very early during boot.

    Type                00000040 (EPOW)
    Status:             bypassed new
    Residual error from previous boot.
    EPOW Sensor Value:  00000002
    EPOW warning due to loss of redundancy.
    EPOW general power fault.

I've no clue why firmware thought it was OK to report this
during one of the earliest calls to RTAS; I'm still investiigating
that.

--linas
