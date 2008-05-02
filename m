Return-Path: <linux-kernel-owner+w=401wt.eu-S935028AbYEBP30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbYEBP30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYEBP3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:29:18 -0400
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:44183 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYEBP3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:29:17 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Jakub Jelinek <jakub@redhat.com>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Date: Fri, 2 May 2008 16:26:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Sam Ravnborg <sam@ravnborg.org>, Chris Knadle <Chris.Knadle@coredump.us>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sven-Haegar Koch <haegar@sdinet.de>
References: <20080501235558.GA20637@orac.ofobscurity.com> <20080502135708.GA22929@uranus.ravnborg.org> <20080502141132.GN2255@devserv.devel.redhat.com>
In-Reply-To: <20080502141132.GN2255@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805021626.23487.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008 15:11:32 Jakub Jelinek wrote:
> On Fri, May 02, 2008 at 03:57:08PM +0200, Sam Ravnborg wrote:
> > OK, can anyone confirm that this fails to build which a
> > buggy gcc:
> >
> >
> > void __attribute__((weak)) func(void)
> > {
> >     /* no code */
> > }
> >
> > int main()
> > {
> >     func();
> >     return 0;
> > }
>
> Of course it doesn't fail to build.
[snip]
>  I doubt a runtime testcase is acceptable though for the
> kernel, as the cross compiler used to build the kernel might not be able to
> create userland executables (missing C library, etc.).

I assume the GCC testsuite has the same generic problem, which is probably why 
it uses the -fdump-tree-optimized parameter to gcc. For example:

alistair@just:~$ cat test.c
void __attribute__((weak)) func(void)
{
    /* no code */
}

int main()
{
    func();
    return 0;
}

alistair@just:~$ gcc -O2 -fdump-tree-optimized test.c
alistair@just:~$ rm -f a.out
alistair@just:~$ cat test.c*.optimized | egrep "func \\(\\);"
  func ();

Ergo, my compiler isn't buggy. As this doesn't require a runtime test I think 
it would be OK for the kernel.

Of course, whether or not it's worth it is now debatable, given the 
information Sven-Haegar Koch provided (Debian's GCC version number is 
actually 4.1.2).

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
