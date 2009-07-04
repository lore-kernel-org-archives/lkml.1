Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZGDGhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZGDGhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 02:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZGDGhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 02:37:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45091 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZGDGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 02:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o2upElHckb5yBdrmK2o81XH3MpE1KgxWyubUXpnTK7VGM4+XxriNmbE/w5uMCeF7Cq
         vNlpQ4IdgqaEIiEyOcG2X+iT5ytXgUdewg8+Ry5FL80i3fNg/MWo1gn+BkmONGVvX0yQ
         uI4R89EtqLymdgvwH3xL3ItEsNyerlwSxcLTs=
Date: Sat, 4 Jul 2009 08:36:46 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: andres@anarazel.de, arun@linux.vnet.ibm.com, tglx@linutronix.de,
       shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090704063646.GA3410@ami.dom.local>
References: <20090703120301.GD4847@ff.dom.local> <20090703.132220.57384838.davem@davemloft.net> <20090703225640.GA3639@ami.dom.local> <20090703.185553.218218176.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703.185553.218218176.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 06:55:53PM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Sat, 4 Jul 2009 00:56:40 +0200
> 
> > On Fri, Jul 03, 2009 at 01:22:20PM -0700, David Miller wrote:
> >> Well, if you look at that commit the bisect pointed to Jarek, it is a
> >> change which starts causing a situation which never happened before.
> >> Namely, timers added on one cpu can be migrated and fire on another.
> >> 
> >> So this could be exposing races in the networking that technically
> >> always existed.
> > 
> > I'm not sure I get your point; could you give some example?
> > Actually, I've suspected races in timers code.
> 
> Let's say that a particular networking timer always gets
> re-added on the cpu where the timer fires.
> 
> In that case, beforehand, no inter-cpu races could possibly
> be tested.  But with the new timer code, such races could
> now be potentially triggered.

Maybe I still miss something, but even if it were possible, lockdep
should have reported such things long ago.

Jarek P.
