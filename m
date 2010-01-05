Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193Ab0AER47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0AER47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0AER46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:56:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab0AER46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:56:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] sparc: copy_from_user() should not return -EFAULT
Date: Tue, 5 Jan 2010 18:55:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Zankel <chris@zankel.net>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <20100105053117.6a7c3377@infradead.org> <20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051855.59100.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX180tgqEEN+mo050VKs7nn4XCY0av0ECrarYD1u
 rSeJBq3HOgtUt3XlOmRMrWU6MBDaqoRzTOKJswQ5XiXu23nzss
 bEpCgvGDHjDklXNLPCISQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Heiko Carstens wrote:
> Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Callers of copy_from_user() expect it to return the number of bytes
> it could not copy. In no case it is supposed to return -EFAULT.
> 
> In case of a detected buffer overflow just return the requested
> length. In addition one could think of a memset that would clear
> the size of the target object.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

The xtensa clear_user function seems to have a similar issue,
it should return size on failure, not -EFAULT.

	Arnd
