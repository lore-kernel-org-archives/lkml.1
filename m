Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZIXAIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZIXAIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZIXAIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:08:52 -0400
Received: from ozlabs.org ([203.10.76.45]:58664 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZIXAIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:08:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: module: Speed up symbol resolution during module loading
Date: Thu, 24 Sep 2009 09:38:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <1253626112-18429-1-git-send-email-alan-jenkins@tuffmail.co.uk> <200909231002.16759.rusty@rustcorp.com.au> <4ABA523F.7000601@tuffmail.co.uk>
In-Reply-To: <4ABA523F.7000601@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909240938.54063.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 02:22:15 am Alan Jenkins wrote:
> [CC to lkml fixed :-/]
> 
> Rusty Russell wrote:
> > On Tue, 22 Sep 2009 10:58:28 pm Alan Jenkins wrote:
> >   
> >> The following series applies against v2.6.31. It sorts the tables of builtin
> >> symbols, so the module loader can resolve them using a binary search.
> >>
> >> The kbuild changes to achieve this are less scary than I expected.  I'm
> >> optimistic that they can be accepted without radical alteration :-).
> >>
> >> Quoting from the last patch in this series:
> >>
> >> "On my EeePC 701, coldplug is mainly cpu bound and takes 1.5 seconds
> >> during boot. perf showed this change eliminated 20% of cpu cycles during
> >> coldplug, saving 0.3 seconds of real time.
> >>     
> >
> > Hi Alan,
> >
> >    This seems useful, but wouldn't it be simpler to just sort at boot time?
> > The same could be done for modules, possibly reducing code.
> >
> > Alternately, there's a standard way of hashing ELF symbols, but I'm not sure
> > we can convince the linker to generate it for vmlinux (I haven't looked
> > though).
> >
> > Thanks!
> > Rusty.
> >   
> 
> I'm concerned that people would object to the extra overhead at boot
> time.  I've hacked up a prototype to sort at boot time and it takes 7ms
> on the same hardware.

OK, that seems a lot to me.  Fair enough; if Sam acks the build parts, I'll
put it in my tree.  A bit late for this merge window though.

Thanks!
Rusty.
