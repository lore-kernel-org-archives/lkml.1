Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbYEBO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbYEBO5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbYEBO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:57:45 -0400
Received: from gw.goop.org ([64.81.55.164]:54046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYEBO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:57:44 -0400
Message-ID: <481B2BE6.3050708@goop.org>
Date: Fri, 02 May 2008 07:57:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>,
       Chris Knadle <Chris.Knadle@coredump.us>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
References: <20080501235558.GA20637@orac.ofobscurity.com> <200805021055.10602.alistair@devzero.co.uk> <20080502104348.GC20741@uranus.ravnborg.org> <200805021248.56797.alistair@devzero.co.uk> <20080502135708.GA22929@uranus.ravnborg.org>
In-Reply-To: <20080502135708.GA22929@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> OK, can anyone confirm that this fails to build which a
> buggy gcc:
>
>
> void __attribute__((weak)) func(void)
> {
>     /* no code */
> }
>
> int main()
> {
>     func();
>     return 0;
> }
>   

I think the problem is that main() would have no call to func(), not 
that it wouldn't build.

Does making func noinline fix it?  I wonder if we should make __weak 
implicitly make the function noinline too.

    J
