Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013Ab0AEVtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0AEVtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782Ab0AEVtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:49:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0AEVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:49:40 -0500
Message-ID: <4B43B2D7.6000208@zytor.com>
Date: Tue, 05 Jan 2010 13:44:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001051445.26149.arnd@arndb.de> <20100105055224.39f9efff@infradead.org> <201001051620.38943.arnd@arndb.de>
In-Reply-To: <201001051620.38943.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 07:20 AM, Arnd Bergmann wrote:
> 
> You mean like this?
> 
> It adds some complexity and about 200 bytes of object code,
> I'm not sure it's worth it.
> 

What's much worse is that it adds churn to an otherwise-tested code path.

We almost need a copy_from/to_user_audited() to override the warning.
Not that errors can't creap back in...

> --
> [UNTESTED PATCH] tun: avoid copy_from_user size warning
> 
> For 32 bit compat code, the tun driver only copies the
> fields it needs using a short length, which copy_from_user
> now warns about. Moving the copy operation outside of the
> main ioctl function lets us avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

	-hpa

