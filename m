Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbZCaTCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbZCaTCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZCaTC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:02:28 -0400
Received: from lazybastard.de ([212.112.238.170]:35184 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZCaTC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:02:27 -0400
X-Greylist: delayed 921 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 15:02:27 EDT
Date: Tue, 31 Mar 2009 21:02:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Detailed Stack Information Patch [0/3]
Message-ID: <20090331190214.GB25879@logfs.org>
References: <1238511498.364.60.camel@matrix> <87eiwdn15a.fsf@basil.nowhere.org> <1238523735.3692.30.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238523735.3692.30.camel@matrix>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 March 2009 20:22:15 +0200, Stefani Seibold wrote:
> Am Dienstag, den 31.03.2009, 17:49 +0200 schrieb Andi Kleen:
> > Stefani Seibold <stefani@seibold.net> writes:
> 
> > > - Misuse the thread stack for big temporary data buffers
> > 
> > That would be better checked for at compile time
> > (except for alloca, but that is quite rare)
> 
> Fine but it did not work for functions like:
> 
> void foo(int n)
> {
> 	char buf[n*1024];
> 
> }
> 
> This is valid with gcc.

Good call.  checkstack should look for those as well.  It is certainly
possible to detect statically and warn about:

  10:   29 c4                   sub    %eax,%esp

Runaway recursions are a different matter, though.  The code I once had
to detect them depends on an old version of smatch, which in turn
depends on gcc 3.1.  And even assuming this was in a reasonable shape, I
still don't know what to do about it.  The kernel has thousands of
recursions and trying to work out how deep each one may stack is a
never-ending project.

Jörn

-- 
A quarrel is quickly settled when deserted by one party; there is
no battle unless there be two.
-- Seneca
