Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZCDSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZCDSAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbZCDSAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:00:13 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:53704 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbZCDSAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:00:11 -0500
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Joao Correia <joaomiguelcorreia@gmail.com>
Subject: Re: some tc commands fail on 2.6.29-rc6-git5, works on 2.6.28.7
Date: Wed, 4 Mar 2009 19:59:57 +0200
User-Agent: KMail/1.9.9
Cc: John Dykstra <john.dykstra1@gmail.com>,
       Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
References: <a5d9929e0903011636w6bff1032y28ab58c0ff8c8052@mail.gmail.com> <1236135028.7883.44.camel@Maple> <a5d9929e0903040609x43dbeda9h26a882897a177400@mail.gmail.com>
In-Reply-To: <a5d9929e0903040609x43dbeda9h26a882897a177400@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903041959.57439.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe good idea to use strace? (i dont know which flags useful, but usually i 
use "-s 65536")
Just maybe it will give a bit more ideas what is happening.
But sure netdev developers can tell, if it is useful or not.

On Wednesday 04 March 2009 16:09:57 Joao Correia wrote:
> Hello
>
> Just to confirm that i also have all traffic control/shaping (QoS,
> connection limits, scheduling, etc) enabled on the config i use.
>
> Its not just the specific version of tc i posted, i tried one from
> last year (october, but i didnt note the exact build) with the same
> result.
>
> Cheers,
> Joao Correia
> Centro de Informatica
> Universidade da Beira Interior
> Portugal
>
> On Wed, Mar 4, 2009 at 2:50 AM, John Dykstra <john.dykstra1@gmail.com> 
wrote:
> > On Tue, 2009-03-03 at 23:10 +0000, Joao Correia wrote:
> >> I have confirmed again that the exact same commands (as on the
> >> original message), work flawlessly on 2.6.28.7 without a hitch, and,
> >> AFAIK, work as intended. I have also tried the latest 2.6.29-rc6-git7
> >> and it still fails like on git6.
> >
> > I have also reproduced this on Linus' latest 2.6.29-rc6 tree, using tc
> > version iproute2-ss071016 and a kernel config with all traffic control
> > features enabled.
> >
> > The error reported by tc comes from the kernel-level check added by:
> >
> >        commit c1b56878fb68e9c14070939ea4537ad4db79ffae
> >        Author: Stephen Hemminger <shemminger@vyatta.com>
> >        Date:   Tue Nov 25 21:14:06 2008 -0800
> >
> >        tc: policing requires a rate estimator
> >
> >    Found that while trying average rate policing, it was possible to
> >    request average rate policing without a rate estimator. This results
> >    in no policing which is harmless but incorrect.
> >
> >    Since policing could be setup in two steps, need to check
> >    in the kernel.
> >
> >    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >    Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > I got the same error when using the tc version iproute2-ss090115 built
> > this evening from the public git repository.
> >
> >  -- John
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


