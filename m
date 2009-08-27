Return-Path: <linux-kernel-owner+w=401wt.eu-S1751020AbZH0REr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbZH0REr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZH0REq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:04:46 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:52268 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750739AbZH0REq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:04:46 -0400
Date: Thu, 27 Aug 2009 13:04:37 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Chris Friesen <cfriesen@nortel.com>
cc: raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <4A96B997.1070001@nortel.com>
Message-ID: <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Chris Friesen wrote:

> I just went and read the docs.  One of the things I noticed is that it
> says that the offlined cpu cannot run userspace tasks.  For our
> situation that's a showstopper, unfortunately.

It needs to be implemented the right way. Essentially this is a variation
on the isolcpu kernel boot option. We probably need some syscall to move
a user space process to a bare metal cpu since the cpu cannot be
considered online in the regular sense.

An isolated cpu can then only execute one process at a time. A process
would do all initialization and lock itsresources in memory before going
to the isolated processor. Any attempt to use OS facilities need to cause
the process to be moved back to a cpu with OS services.


