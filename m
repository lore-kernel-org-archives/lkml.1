Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbXFURsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbXFURsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXFURsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:48:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbXFURsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:48:30 -0400
Subject: Re: JIT emulator needs
From: Arjan van de Ven <arjan@infradead.org>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 21 Jun 2007 10:44:44 -0700
Message-Id: <1182447884.2704.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 02:35 -0400, Albert Cahalan wrote:
> Right now, Linux isn't all that friendly to JIT emulators.
> Here are the problems and suggestions to improve the situation.
> 
> There is an SE Linux execmem restriction that enforces W^X.
> Assuming you don't wish to just disable SE Linux, there are
> two ugly ways around the problem. You can mmap a file twice,
> or you can abuse SysV shared memory. The mmap method requires
> that you know of a filesystem mounted rw,exec where you can
> write a very large temporary file. This arbitrary filesystem,
> rather than swap space, will be the backing store. The SysV
> shared memory method requires an undocumented flag and is
> subject to some annoying size limits. Both methods create
> objects that will fail to be deleted if the program dies
> before marking the objects for deletion.


and these methods also destroy yourself on any machine with a looser
cache coherency between I and D-cache....

for all but x86 you pretty much have to do the mprotect() between the
two states to deal with the cache flushing properly...



