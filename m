Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZHCRze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZHCRze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZHCRzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:55:33 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:8435 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbZHCRzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:55:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build failure
Date: Mon, 3 Aug 2009 11:55:27 -0600
User-Agent: KMail/1.9.10
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
References: <20090803133203.81174a8e.sfr@canb.auug.org.au>
In-Reply-To: <20090803133203.81174a8e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031155.28386.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009 09:32:03 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/acpi/osl.c: In function 'bind_to_cpu0':
> drivers/acpi/osl.c:194: error: implicit declaration of function 'set_cpus_allowed'
> 
> Caused by commit 74b5820808215f65b70b05a099d6d3c969b82689 ("ACPI: bind
> workqueues to CPU 0 to avoid SMI corruption") (from the acpi tree but now
> in Linus' tree) interacting with commit
> 17e249fb40c814a72f08c1356cb47ec9f87f81a8
> ("cpumask:remove-set_cpus_allowed") from the rr tree.
> 
> I have reverted that rr tree commit for today.

Looks like I'm doing this the wrong way (by passing a cpumask on the
stack).  I'll try to figure out the approved way of doing this and
send a followup patch.

Bjorn

