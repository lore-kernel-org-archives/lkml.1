Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZGaWCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZGaWCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 18:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZGaWCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 18:02:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64597 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbZGaWCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 18:02:30 -0400
Date: Fri, 31 Jul 2009 18:02:07 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Richard Henderson <rth@twiddle.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: use .data.init_task instead of
 .data.init_thread.
In-Reply-To: <4A7360C3.2060507@twiddle.net>
Message-ID: <alpine.DEB.1.10.0907311739040.2539@vinegar-pot.mit.edu>
References: <1249073786-29788-1-git-send-email-tabbott@ksplice.com> <4A7360C3.2060507@twiddle.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Richard Henderson wrote:

> On 07/31/2009 01:56 PM, Tim Abbott wrote:
> > -	/* Note 2 page alignment above.  */
> > -	.data.init_thread : {
> > -		*(.data.init_thread)
> > -	}
> 
> NACK.
> 
> You can change the section name, sure, but you cannot remove the 2 page
> alignment that we had via the alignment at the end of the init sections.
> You'll break current_thread_info which is always computed as
> (kernel-stack-pointer & -(2*PAGE_SIZE)).

The INIT_TASK_DATA(THREAD_SIZE) macro call aligns to THREAD_SIZE (= 
2*PAGE_SIZE).  So I'm not removing the 2 page alignment; I'm just moving 
it along with the code that needs to be aligned.

This change:

-	. = ALIGN(2 * PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);
 	__init_end = .;

removes the now-unnecessary (2 * PAGE_SIZE) alignment for __init_end 
caused by moving .data.init_task (it should have been in the first patch).

	-Tim Abbott
