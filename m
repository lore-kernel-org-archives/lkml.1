Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXJ2Tpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXJ2Tpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXJ2TlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:41:15 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:42847 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753864AbXJ2TlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:41:13 -0400
Message-ID: <4726377A.4080807@crispincowan.com>
Date: Mon, 29 Oct 2007 12:41:46 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: rmeijer@xs4all.nl
CC: casey@schaufler-ca.com, Chris Wright <chrisw@sous-sol.org>,
       Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to   
        static interface)
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
In-Reply-To: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Meijer wrote:
> On Mon, October 29, 2007 11:24, Crispin Cowan wrote:
>   
>>> Thus IMHO it may be a good idea to instead of a maintainer for LSM
>>> modules as proposed, alternatively a maintainer for each formal model
>>> may be more appropriate. This also would require module builders to
>>> first
>>> think about what formal model they are actualy using, thus resulting in
>>> cleaner module design.
>>>       
>> I *really* dislike this idea. It seems to set up the situation that the
>> only acceptable modules are those that follow some "formal" model.
>> Problems:
>> ...
>>     * The proposal only allows a single implementation of each formal
>>       model. In theory, theory is just like practice, but in practice it
>>       is not. SMACK and SELinux follow substantially similar formal
>>       models (not exactly the same) so should we exclude one and keep
>>       the other? No, of course not, because in practice they are very
>>       different.
>>     
> I would think the two may benefit from a role as described above.
> But I was thinking more in the line of new modules that may again
> implement this same model, and would thus benefit from interaction with
> this 'model maintainer' role.
>   
Ah! So the proposal really is to have an LSM maintainer for each
"family" of models, acting as a resource and arbiter for modules in a class.

I like that idea, and have no objection to it. However, it does have
resource problems, in that the pool of LSM maintainers is not that
large. There is also the likely objection that this degree of scale is
not needed until at least there are multiple families of models in the
upstream kernel, and possibly until there are multiple instances of a
single family in the upstream kernel.

It also begs the question of what constitutes a family.

    * AppArmor, SELinux, and TOMOYO are all ambient capability systems
          o AppArmor and TOMOYO are pathname based
          o SELinux is label based
    * SELinux and SMACK are label-based
          o I don't know if SMACK is an ambient capability system
    * Rob Meijer implicitly advocated for an object capability LSM
          o would it be pathname or label based? You could do either or
            both ...
    * The LSPP work from RH, Tresys, and TCS is MLS based
          o this is a subset of both label-based and ambient capability
            based
    * I have no clue what family to put MultiADM or Dazuko into
    * Getting very formal, I could imagine a Clarke-Wilson module
    * Getting very informal, I could imagine a module that is a
      collection of cute intrusion prevention hacks, such as the Open
      wall Linux symlink and hardlink restrictions, and my own RaceGuard
      work
          o Oh wait, I published
            <http://citeseer.ist.psu.edu/cowan01raceguard.html>
            RaceGuard. Does that make it formal? :-)

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

