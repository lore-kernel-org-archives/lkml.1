Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXJ1PAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXJ1PAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXJ1PA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:00:26 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:40031 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXJ1PAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:00:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=J/JUt5mV6IZU9da+v9dV0rP+FS+avYYFdXRa4t9vqBZ8pAjkLKY62NjC0fD8+1Wwqx4y7hFKfAX52SxsUEr1svAcDIvZVCCai0drjtqW3E39K5g7j2JR/VYtWY/JkFOH;
Message-ID: <4724A3ED.9070703@simon.arlott.org.uk>
Date: Sun, 28 Oct 2007 14:59:57 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Tilman Schmidt <tilman@imap.cc>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: eradicating out of tree modules
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724557C.6000408@s5r6.in-berlin.de> <47247A1C.8010406@imap.cc> <47249E8C.4070001@s5r6.in-berlin.de>
In-Reply-To: <47249E8C.4070001@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/07 14:37, Stefan Richter wrote:
> Tilman Schmidt wrote:
>> Am 28.10.2007 10:25 schrieb Stefan Richter:
>>> You two are hypothesizing.
>> 
>> No, we're not. We're discussing the very real issue of whether
>> LSM should be amputated in such a way as to make life difficult
>> for out of tree security module developers.
> 
> I still believe you are.  From what I understood, the API change had
> technical reasons.  (What I have read is that using security modules in
> the form of loadable and unloadable kernel modules didn't make sense.)

Stacking modules makes a lot of sense, it may be tricky to order sensibly, 
now if you want the features of more than one LSM (including those being 
added to the kernel), you need to *copy* the parts you want. Since you 
can't use modules to load them, because that feature's been removed, you 
need to maintain your own kernel tree for it or submit your changes which 
will eventually end up with LSMs that all do the same thing...

This static LSM doesn't even make sense to me - what happens if I select 
both SECURITY_CAPABILITIES and SECURITY_ROOTPLUG? I can't easily check 
because I'm using 2.6.23 - so I can still reload my module while changing 
it to have a better configuration interface. Kconfig doesn't look like it 
will prevent it. Surely the options should be a multiple choice menu?


Adrian's mentioned people eager to write drivers - LSMs aren't drivers, 
there's really nothing to work from except "security module that does X" 
and for that people should develop what they want themselves.

There's no reason for out of tree *GPL* drivers to not exist, is there?
How much of the non-driver code that gets merged into the kernel exists 
first as out of tree modules, rather than direct patches to the tree 
itself? It was made much easier since 2.4 to compile a module out of tree 
using a simple Makefile. (Perhaps that should be removed too?)

-- 
Simon Arlott
