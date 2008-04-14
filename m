Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbYDNOyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbYDNOyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbYDNOyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:54:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:48945 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406AbYDNOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DOByJnWupyyANm6K9ad+8GmoKC6Ecjc+LtMo4W5JMBkOpUCv8KnMhfIjmtLnGW1vS67cKH3yyOZiDlyUCFmxUnvCZkgaR2OrOiOOgsbPSHq8WAyfESbGpMxLxYwjf7GD2fhY0askjZFBqukmlgvj8jZ+eA4W801WTd+YqMu1Buo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Denis V. Lunev" <den@openvz.org>
Subject: Re: Does process need to have a kernel-side stack all the time?
Date: Mon, 14 Apr 2008 16:54:22 +0200
User-Agent: KMail/1.8.2
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200804141547.57719.vda.linux@googlemail.com> <1208182649.7688.7.camel@iris.sw.ru>
In-Reply-To: <1208182649.7688.7.camel@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141654.22513.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 16:17, Denis V. Lunev wrote:
> On Mon, 2008-04-14 at 15:47 +0200, Denys Vlasenko wrote:
> > Currently, when process sleeps, we save some
> > state in stack, and such a change may require
> > some substantial surgery.
> > 
> > Can you tell me whether this is possible at all,
> > and how difficult you estimate it to be?
> 
> I do not think that this can help. Usually, the process (thread) invokes
> some syscall like sleep and goes to the waiting state _from the kernel_,
> i.e. the kernel stack is used at that moment and will be required during
> wake up.

See my quote above. That's exactly what I said. This is how it currently
works.

But do you really need 4k to remember that "this thread went to sleep by
executing sleep(60)"? Theoretically, you may get away with much smaller
save area to remember that, and be able to wake up and return to userspace.
--
vda
