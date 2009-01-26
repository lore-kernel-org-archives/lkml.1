Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZAZTyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZAZTyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZAZTyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:54:15 -0500
Received: from gw.goop.org ([64.81.55.164]:41002 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZAZTyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:54:14 -0500
Message-ID: <497E14E3.2080509@goop.org>
Date: Mon, 26 Jan 2009 11:54:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Xen-devel] [PATCH 2/2] x86: add	 pte_set_flags/clear_flags	
 forpteflag manipulation
References: <4978F216.5040803@goop.org> <49798A5E.76E4.0078.0@novell.com> <497A3117.2070809@goop.org> <497D798C.76E4.0078.0@novell.com>
In-Reply-To: <497D798C.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Whether a pte is live doesn't matter here: If you change P on Xen, the
> frame number representation *must* change from/to PFN to/from MFN.
> In no case (other than iomem pages) is it allowed to flip just this bit.

Yes, true. Same with _PAGE_SPECIAL, which is actually flipped by code 
here.  I guess a warning here might be useful, but really the calling 
code needs to be properly disciplined; after all setting P on a swap 
entry is no fun either.

    J
