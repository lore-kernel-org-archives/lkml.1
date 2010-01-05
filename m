Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945Ab0AEBkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0AEBkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422Ab0AEBkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:40:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0AEBkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:40:40 -0500
Date: Mon, 4 Jan 2010 17:43:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100104174308.0790757c@infradead.org>
In-Reply-To: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 16:43:45 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Hi Arjan,
> 
> I was just about to port the strict copy_from_user checks to s390, but
> I have some issues with it:
> 
> Is there a reason why there isn't a generic infrastructure that simply
> can be 'selected' by each architecure? I guess there isn't ;)

the compiler.h side is already generic; just that the copy from user
itself is different between architectures.

> x86 and sparc return -EFAULT in copy_from_user instead of the number
> of not copied bytes as it should in case of a detected buffer
> overflow. That might have unwanted side effects. I would guess that
> is a bug.

killing the bad guy in case of a real buffer overflow is appropriate..
this should never trigger for legitimate users.

> 
> Warnings cannot be switched off anymore as it was the case in your
> first version. However gcc seems to report quite a few false
> positives so it would be good if it could be turned off again.

hmm I thought most got fixed.. I'd be surprised if this part is
architecture specific.....
I rather fix the few cases left than disable the warning to be honest.
It's not many, at least not on x86.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
