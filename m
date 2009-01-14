Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZANN51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZANN51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZANN5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:57:15 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:41351 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZANN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:57:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xa5xyEuYOsGN024+YfNPdrwM+VV6tTKJ/wlgiFxrJRQJ9zKpLjUXBCfvG7z7TgtBoq
         eZgcgXbektuFhUXOK0uQPjm4J2+dYciaa77uUoD7y4JGrrgkm2plCSmWxfHVhh8Sn/po
         UtEuAy6LYIHVzhnqd5rVVLsW5nsfz5yYd8diY=
Date: Wed, 14 Jan 2009 13:57:06 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Denys Fedoryschenko <denys@visp.net.lb>, Chris Caputo <ccaputo@alt.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090114135706.GE6117@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <200901141417.58667.denys@visp.net.lb> <1231937404.14825.4.camel@laptop> <200901141505.46929.denys@visp.net.lb> <20090114131257.GC6117@ff.dom.local> <1231938929.14825.6.camel@laptop> <20090114132603.GD6117@ff.dom.local> <1231939946.14825.9.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231939946.14825.9.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:32:26PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-01-14 at 13:26 +0000, Jarek Poplawski wrote:
> 
> > OK, I hope Denys can apply more, but what about others? Without any
> > patches the hole seems to be much bigger.
> 
> OK, I read most of this thread on netdev, but didn't find a clear clue
> on the specific hrtimer insertion race.
> 
> Do you have any clear ideas or should I poke at the htb/hrtimer code a
> little?
> 

I didn't diagnose this entirely, and there were "a few" days since I
wrote my opinion on this, so currently I forgot details, but I guess
the most suspicious place is adding a hrtimer, when it's on the list,
maybe even two times in a row. I guess it's not removed from the
rbtree in some case. (I stopped searching after seeing you removed
this list or something...)

Jarek P.
