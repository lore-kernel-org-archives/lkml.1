Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbYESP2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbYESP2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYESP14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:27:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbYESP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:27:55 -0400
Date: Mon, 19 May 2008 08:26:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       Shaohua Li <shaohua.li@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: recent 2.6.26 kernel hangs at suspend
In-Reply-To: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805190822440.32253@woody.linux-foundation.org>
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008, Jeff Chua wrote:
> 
> How can I get pass the "bad" commit. I've tried "skip" or "next", but
> still won't boot.

Try

	git bisect visualize

and pick any commit that is active (avoiding the endpoints) and looks like 
a good candidate to test. Then do "git reset --hard <that-commit>" and try 
again..

Of course, when there are two overlapping bugs, and the other hides the 
bug you are trying to chase down, there *will* be cases where bisect 
simply doesn't work, if you are unlucky. Bisecting is wonderful, but it's 
not going so solve world hunger, or even be able to help with _all_ 
problems.

			Linus
