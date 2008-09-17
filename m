Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYIQSQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYIQSQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYIQSQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:16:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:44555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754622AbYIQSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:16:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+SKl0T40aSsh77gS2gskzpqsj5G+BqUWdER4CXXl
	rSenBNNrh+E1Yv
Subject: Re: [Bug #11308] tbench regression on each kernel release
	from	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
In-Reply-To: <48D11871.4090805@cosmosbay.com>
References: <1221306287.5213.111.camel@marge.simson.net>
	 <48CD1D25.9080301@linux-foundation.org>
	 <1221421907.4597.24.camel@marge.simson.net>
	 <1221475440.4784.39.camel@marge.simson.net>
	 <1221568105.5020.17.camel@marge.simson.net>
	 <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>
	 <1221626391.5043.13.camel@marge.simson.net>
	 <1221627676.5125.3.camel@marge.simson.net> <20080917104044.GC18764@elte.hu>
	 <1221651701.5102.17.camel@marge.simson.net> <20080917124943.GA7738@elte.hu>
	 <1221657111.5511.14.camel@marge.simson.net>
	 <48D11871.4090805@cosmosbay.com>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 20:16:11 +0200
Message-Id: <1221675371.5030.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 16:47 +0200, Eric Dumazet wrote:

> Could you please try following patch ?
> 
> [PATCH] security_ops moved to read_mostly section
> 
> "struct security_operations *security_ops" should be moved to read_mostly 
> section in order to NOT let it share a cache line with higly modified variables.

v2.6.26-974-g2846693 (tip of revert reverts tree, == 847106f)
16384  87380  1        1       60.00    94350.45
16384  87380  1        1       60.01    95857.25
16384  87380  1        1       60.00    95334.84
16384  87380  1        1       60.00    95052.11

v2.6.26-659-g7804ad8 (first commit prior, == 2069f45)
16384  87380  1        1       60.00    98630.64
16384  87380  1        1       60.00    98653.14
16384  87380  1        1       60.00    99162.65
16384  87380  1        1       60.00    98652.38

v2.6.26-974-g2846693 patched
16384  87380  1        1       60.00    95877.41
16384  87380  1        1       60.00    95810.27
16384  87380  1        1       60.00    95530.03
16384  87380  1        1       60.00    94968.12

(poo, "it" didn't die)

