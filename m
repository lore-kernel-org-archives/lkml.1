Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXGFFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXGFFoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXGFFoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:44:08 -0400
Received: from gw.goop.org ([64.81.55.164]:59738 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbXGFFoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:44:07 -0400
Message-ID: <468DD6A5.4020705@goop.org>
Date: Thu, 05 Jul 2007 22:44:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Dan Kegel <dank@kegel.com>
CC: linux-kernel@vger.kernel.org, Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com>
In-Reply-To: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Kegel wrote:
> It'd be nice to see if Valgrind could catch uninitialized
> references in the kernel, if only to see if Coverity is
> missing anything that happens in practice.
>
> Back in December 2002, Valgrind started to run UML:
> http://user-mode-linux.sourceforge.net/diary.html
> http://marc.info/?l=linux-kernel&m=104035199923121&w=2
> but it wasn't quite usable, and it seems broken since then.
> The last note I could find about this was from Jeff In July 2005:
> http://marc.info/?l=linux-kernel&m=112273702329952&w=2
>
> Has there been any motion since then? 

Not that I know of.  I think all the pieces are in place now.  The 
original problem was that Valgrind didn't deal with clone and didn't 
have accurate signal support.  I fixed that.  Then the problem was 
dealing with the densely packed small kernel stacks.  Valgrind now has a 
way of registering stack regions, so that it can distinguish between a 
stack switch and a normal function call.

So, I think all it needs now is to scatter some valgrind client requests 
around the kernel and give it a spin.  See, simple ;)

    J
