Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZEDJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZEDJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZEDJ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:56:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54066 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZEDJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:56:11 -0400
Subject: Re: introducing __GFP_PANIC
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090504084916.GB4173@lenovo>
References: <20090503121228.GC4615@lenovo>
	 <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo>
	 <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com>
	 <20090503172338.GG4615@lenovo>
	 <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
	 <20090503204542.GJ4615@lenovo>
	 <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
	 <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop>
	 <20090504084916.GB4173@lenovo>
Date: Mon, 04 May 2009 12:56:09 +0300
Message-Id: <1241430969.21088.20.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 12:49 +0400, Cyrill Gorcunov wrote:
> | __GFP_PANIC is an annotation saying that it's okay for a particular
> | call-site not to check for NULL because we never expect to run out of
> | memory at that point. But we don't really need to panic() for all the
> | possible *errors*, just for the out-of-memory case.
> | 
> | 			Pekka
> | 
> 
> Which means, __GFP_PANIC will not grant the guarantee to a caller
> that he will not get NULL deref even with __GFP_PANIC specified?

Yes, __GFP_PANIC will guarantee that you never return NULL for
_out-of-memory_ but makes no guarantees what happens if you pass bogus
size or order.

