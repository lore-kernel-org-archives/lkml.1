Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZF2SE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZF2SE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZF2SEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:04:44 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46380 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZF2SEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lOZnt5VaEfkaZkd+be1V6QRtaxPdhxe4Cj/CshYGnvBS8j/NKPSJtU8xFxw29tfrXq
         jfc8KRIVY7bDs8w5YHidJgXJDv8M/s9pl4dNP0rfOtYRFeIGc+W4iSL2B7a6d2oRdbsz
         QzR+jN+jC7LjGJsZsy9TW47Eqo4dS9v2kMTGo=
Date: Mon, 29 Jun 2009 20:04:31 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
	callbacks
Message-ID: <20090629180431.GE2742@ami.dom.local>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.1.10.0906290826300.29966@makko.or.mcafeemobile.com> <20090629173217.GC2742@ami.dom.local> <alpine.DEB.1.10.0906291033140.30244@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906291033140.30244@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 10:36:30AM -0700, Davide Libenzi wrote:
> On Mon, 29 Jun 2009, Jarek Poplawski wrote:
> 
> > > I think Oleg already said this, but you can use directly poll_wait() 
> > > without adding another abstraction, and the compiler will drop the double 
> > > check for you:
> > 
> > I think Oleg told about cosmetics and let Jiri to choose. I'd only
> > add it's not mainly about optimization, but easy showing the main
> > difference, of course depending on taste.
> 
> We already have a universally used function to do that, and that's 
> poll_wait().
> That code (adding an extra __poll_wait()) was entirely about 
> optimizations (otherwise why not use the existing poll_wait()?), so if 
> the optimization does not actually take place, IMO it's better to not add 
> an extra API.

OK, you're right, it is about optimization! But IMHO mainly about
reading optimization... I simply guess me and probably Jiri too,
after reading Oleg's variant thought about compiler, instead of the
real difference.

Btw., maybe I miss something but I guess Oleg proposed something in
between: inlining __poll_wait(), which would save us 'extra API' and
compiler doubts. (But I still prefer Jiri's choice. ;-)

Jarek P.
