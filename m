Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738Ab0AHAB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0AHAB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324Ab0AHAB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:01:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0AHAB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:01:28 -0500
Message-ID: <4B4674FF.5070700@zytor.com>
Date: Thu, 07 Jan 2010 15:57:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001051620.38943.arnd@arndb.de> <4B43B2D7.6000208@zytor.com> <201001071502.29777.arnd@arndb.de>
In-Reply-To: <201001071502.29777.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 06:02 AM, Arnd Bergmann wrote:
> On Tuesday 05 January 2010, H. Peter Anvin wrote:
>> What's much worse is that it adds churn to an otherwise-tested code path.
>>
>> We almost need a copy_from/to_user_audited() to override the warning.
>> Not that errors can't creap back in...
>>
> 
> Maybe just splitting it up into access_ok() and __copy_from_user(),
> plus a comment is enough? That way we don't need to add another interface
> for the rare case.
> 

Adding a named interface makes it clear *what* you are doing and
*why*... just open-coding the implementation does neither.

> On a related topic, one interface that may actually be worth adding is
> a get_user/put_user variant that can operate on full data structures
> and return -EFAULT on failure rather than the number of remaining
> bytes that 99% of the code never need.

What is wrong with checking for zero?

	-hpa

