Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858Ab0AFDST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0AFDST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862Ab0AFDSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:18:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:59280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab0AFDSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:18:17 -0500
Date: Tue, 5 Jan 2010 19:20:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: copy_from_user() should not return -EFAULT
Message-ID: <20100105192040.7b800c82@infradead.org>
In-Reply-To: <87skakbgy1.fsf@basil.nowhere.org>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
	<20100104174308.0790757c@infradead.org>
	<20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
	<201001051347.21309.arnd@arndb.de>
	<20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
	<20100105053117.6a7c3377@infradead.org>
	<20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
	<87skakbgy1.fsf@basil.nowhere.org>
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

On Tue, 05 Jan 2010 18:27:18 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Heiko Carstens <heiko.carstens@de.ibm.com> writes:
> 
> > Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT
> >
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> > Callers of copy_from_user() expect it to return the number of bytes
> > it could not copy. In no case it is supposed to return -EFAULT.
> >
> > In case of a detected buffer overflow just return the requested
> > length. In addition one could think of a memset that would clear
> > the size of the target object.
> 
> Ouch! I would expect this is likely exploitable, e.g. in mount

yeah once you have the buffer overflow there might be another exploit
instead.. so yes needs to be fixed.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
