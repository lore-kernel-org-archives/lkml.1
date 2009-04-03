Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbZDCGtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbZDCGtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZDCGtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:49:07 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:3394 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZDCGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:49:05 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/6] perf_counter: move the event overflow output bits
 to record_type
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49D549E7.1040904@linux.vnet.ibm.com>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.151921176@chello.nl> <49D53D2B.30108@linux.vnet.ibm.com>
	 <49D549E7.1040904@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 08:50:04 +0200
Message-Id: <1238741404.8530.7068.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 16:27 -0700, Corey Ashford wrote:
> Whoops, nevermind.
> 
> My misunderstanding on this one.  This enum is used for event type, not 
> the record_type, and as such is makes sense for there to be exclusive 
> mmap and munmap event records.
> 
> Thinking about this a bit, I'm guessing that the idea is to track the 
> loading and unloading of shared objects which uses mmap and munmap, so 
> that that the ip can be related to a particular object that was mapped 
> in at the time of the counter overflow interrupt.  Is that right?

Indeed, whenever a mmap/munmap happens of a PROT_EXEC range we record
that information so that we can relate the userspace IPs to some file
and hence the actual userspace code.



