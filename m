Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZCJKDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZCJKDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZCJKDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:03:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:52271 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZCJKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=scH91QV+xNLEZLDDgrepohVvrNoajzsVC3Vjy0e9RmayeKWCpi8rinBXAdJOFsVG9t
         4N8WABi81HDsvPUekEsog+9GjAYe/KOA3bpiLToz/XhppsWUg1W0BVRJl/TeW68UvRxy
         xjN6WysRzVOZmaksb6HIm+f4yQC/HyexB4lu4=
Date: Tue, 10 Mar 2009 11:03:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive
	numbers
Message-ID: <20090310100321.GA6825@nowhere>
References: <20090308231850.GB24445@silver.sucs.org> <20090309201503.GA5010@nowhere> <20090310001222.GA1843@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310001222.GA1843@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 12:12:22AM +0000, Sitsofe Wheeler wrote:
> On Mon, Mar 09, 2009 at 09:15:04PM +0100, Frederic Weisbecker wrote:
> > On Sun, Mar 08, 2009 at 11:18:50PM +0000, Sitsofe Wheeler wrote:
> > > Formally negative nice values have started become very big in positive
> > > integers in -tip kernels:
> > > 
> > >     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    
> > 
> > The weird thing here is that number: 2147483647
> > It is 0xefffffff
> > Which means -1 without the highest bit (the sign).
> > I really don't know how it could have happened.
> > 
> > Anyway, I caught something in the signedness bits from my patch that unifies
> > the format decoding.
> > I've never seen your bug on my machine. But I note you have a 32 bits CPU.
> > Mine is 64 bits with a 64 bits kernel. Perhaps some weird signedness related things
> > happened because of the signedness bug that the following patch fixes.
> > 
> > Can you please give it a try?
> 
> This seems to have fixed the problem (unless I'm mistaken):
>     2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd           
> 
> Thanks!
> 
> -- 
> Sitsofe | http://sucs.org/~sits/


Thanks a lot Sitsofe!

Reported-and-tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

