Return-Path: <linux-kernel-owner+w=401wt.eu-S1764156AbXFRRuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764156AbXFRRuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXFRRuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:50:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758998AbXFRRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:50:09 -0400
Date: Mon, 18 Jun 2007 10:48:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: mingo@elte.hu, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <E1I0LEG-0008LQ-00@dorka.pomaz.szeredi.hu>
Message-ID: <alpine.LFD.0.98.0706181046260.14121@woody.linux-foundation.org>
References: <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu>
 <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu>
 <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
 <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
 <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
 <20070618081204.GA11153@elte.hu> <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
 <E1I0LEG-0008LQ-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Miklos Szeredi wrote:
>
> > Hmm? Untested, I know. Maybe I overlooked something. But even the 
> > generated assembly code looks fine (much better than it looked before!)
> 
> Boots and runs fine.  Fixes the freezes as well, which is not such a
> big surprise, since basically any change in that function seems to do
> that ;)

Yeah, and that code really was *designed* to make all "locking in a loop" 
go away. So unlike the patches adding random barriers and cpu_relax() 
calls (which might fix it for some *particular* hw setup), I pretty much 
guarantee that you can never get that code into a situation where there is 
some lock being starved on *any* hw setup.

Ingo, an ack for the patch, and I'll just apply it?

			Linus
