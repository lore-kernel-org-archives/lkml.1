Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZIZUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZIZUs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIZUs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 16:48:27 -0400
Received: from n2a.bullet.mail.ac4.yahoo.com ([76.13.13.65]:26836 "HELO
	n2a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752293AbZIZUsZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 16:48:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 350704.56198.bm@omp124.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=35Yi3oDxD58432jJ6dTNmpnrOprkdiLCJe/YpMRYrfm6EkR4HUwUf2sgY9gjP/dWvg5QDCtAlOPqkNROgU/iCb0HlnmwaagYLHfsbWiAhwR54AXrhBK9niOVvYm+0Ezsr/DytiDBNrFxk3nBoH9AaN3Sm9Bko+V75Qi7OBY67S0=;
Message-ID: <222796.87049.qm@web63403.mail.re1.yahoo.com>
X-YMail-OSG: rNh.qhMVM1kyYQx148zRPqLYvd_VEOEyGm6UBq9z6fhBjSMoZJQeKLTq4xTHjGRSe9T0ramCTIzK1z3JMa8FHNhu30tPhVoOxYh2.Ps4kfKziPHvPJ5bo77_Hdca.uA0XsTg9ie6NCjghjNSnFrK4XRTKmmzmEUxmchewRksrUFuy_sz6bL5cUyHOJRCTfOwKnygf8UKs8_E9rflaxDPhSgw5OUoOmWS.pLXFyoGVXx5D5AMAyEW2cPqOIu7XDT3VQbIEeDrF8fn60npq2mtKbJw5t2RDpmRZWgTf_ImCiQ9oonWNoGVmfa9Jjwx87vc5BvZncXP5MYDbgBGi7iA4GAyxw--
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Sat, 26 Sep 2009 13:48:28 -0700 (PDT)
From: Joe Cao <caoco2002@yahoo.com>
Subject: Re: TCP stack bug related to F-RTO?
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Ray Lee <ray-lk@madrabbit.org>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909262034130.12882@melkinkari.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilpo,

Thanks for the replay.  We noticed the problem while we were debugging a connection failure case reported by one of our customers (we are a network device vendor).  Actually we have suggested our customer to upgrade their server software to fix the problem, and we are still waiting for the feedback from them.  Meanwhile, I asked all those questions just because I want to understand the issue and the fixes.  We also has to convince the customer to move to a right kernel and don't want them to come back with the same problem again.

Again, thanks for the help!

Joe

--- On Sat, 9/26/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Subject: Re: TCP stack bug related to F-RTO?
> To: "Joe Cao" <caoco2002@yahoo.com>
> Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Netdev" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
> Date: Saturday, September 26, 2009, 10:51 AM
> On Sat, 26 Sep 2009, Joe Cao wrote:
> 
> > Can you elaborate on "Some retransmission would happen
> here as step 3"?  
> > When the second timeout happens, it will again go into
> FRTO and then 
> > retransmit the write queue head.
> 
> Why do you think that the second RTO will happen with
> anything else than 
> with 2.6.24. And it's perfectly ok to go into FRTO for the
> second time.
> 
> > I looked at the patch (debian Bug#478062) that's
> probably what you 
> > mentioned as the fix. All it does was to exclude the
> SACK case when 
> > considering FRTO.  But in my case, SACK was
> enabled, as seen in the 
> > trace..
> 
> You should be looking from where I said rather than picking
> up your own 
> sources and assuming that they'll tell you all the story
> :-). In fact, 
> there are two fixes that were made in a row and one
> workaround in the
> same timeframe. ...And you managed to pick the wrong one of
> the fixes, so 
> I kind of understand why you got confused :-).
> 
> > In other words, do we still have a problem with FRTO
> when SACK is 
> > enabled in the latest kernel?
> 
> For sure we might have all kinds of problems no one has yet
> 
> noticed/reported :-). ....However, it seems that this
> particular problem 
> your trace is showing is solved. Can you please test with a
> fixed kernel 
> before coming back here with these claims.
> 
> 
> -- 
>  i.
> 
> --- On Fri, 9/25/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> wrote:
> 
> > From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > Subject: Re: TCP stack bug related to F-RTO?
> > To: "Joe Cao" <caoco2002@yahoo.com>
> > Cc: "Ray Lee" <ray-lk@madrabbit.org>,
> "Netdev" <netdev@vger.kernel.org>,
> "LKML" <linux-kernel@vger.kernel.org>
> > Date: Friday, September 25, 2009, 11:03 AM
> > On Fri, 25 Sep 2009, Joe Cao wrote:
> > 
> > > Thanks for the reply!  Do you happen to know
> > which patch fixed the 
> > > problem?
> > 
> > You can find those patches from the stable queue git
> tree.
> > I gave you hint 
> > from what release to look from in the last mail.
> However,
> > as 2.6.24 is 
> > anyway obsolete my recommendation is that you should
> > probably consider 
> > upgrading to fix all the other bugs that have been
> found
> > since 2.6.24 was 
> > obsoleted.
> > 
> > > Is there a bug tracking system for linux kernel?
> > 
> > Nothing that knows everything about everything.
> > 
> > > I studied the FRTO code in latest kernel
> 2.6.31.. 
> > It seems the problem 
> > > is still there:  
> > >
> > > 1. Every time a RTO fires, because
> tcp_is_sackfrto(tp)
> > returns 1, 
> > > tcp_use_frto() returns true.  And the server
> tcp
> > enters FRTO.
> > > 2. After the head of write queue is
> retransmitted, two
> > new data packets 
> > > are transmitted, the server receives two
> > dup-ACKs.  That will make the 
> > > TCP enter tcp_enter_frto_loss(), however, that
> only
> > rests ssthresh and 
> > > some other fields.
> > 
> > Perhaps those other fields are far more important than
> you
> > think... :-)
> > ...Some retransmission would happen here as step 3.
> > 
> > > 3. After another longer RTO fires, because
> > tcp_is_sackfrto(tp) returns 
> > > 1, tcp_use_frto() again returns true.  The
> stack
> > enters FRTO again.
> > > 4. The above repeats and the stack couldn't
> > retransmits the lost packets 
> > > faster.
> > > 
> > > Is my understanding above correct?
> > 
> > ...No. All magic that happens in tcp_enter_frto_loss
> should
> > be enough to 
> > really do more than a single retransmission (that is,
> in
> > any other than 
> > 2.6.24 series kernel). There was an unfortunate bug in
> this
> > area in 2.6.24 
> > which basically undoed the effect of correct actions
> > tcp_enter_frto_loss 
> > did which effectively prevented
> tcp_xmit_retransmit_queue
> > from doing its 
> > part.
> > 
> > -- 
> >  i.
> > 
> > --- On Fri, 9/25/09, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > wrote:
> > 
> > > From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > > Subject: Re: TCP stack bug related to F-RTO?
> > > To: "Ray Lee" <ray-lk@madrabbit.org>
> > > Cc: "Joe Cao" <caoco2002@yahoo.com>,
> > "Netdev" <netdev@vger.kernel.org>,
> > "LKML" <linux-kernel@vger.kernel.org>,
> > jcaoco2002@yahoo.com
> > > Date: Friday, September 25, 2009, 6:09 AM
> > > On Thu, 24 Sep 2009, Ray Lee wrote:
> > > 
> > > > [adding netdev cc:]
> > > > 
> > > > On Thu, Sep 24, 2009 at 10:43 AM, Joe Cao
> <caoco2002@yahoo.com>
> > > wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > I have found the following behavior
> with
> > > different versions of linux 
> > > > > kernel. The attached pcap trace is
> collected
> > with
> > > server 
> > > > > (192.168.0.13) running 2.6.24 and shows
> the
> > > problem. Basically the 
> > > > > behavior is like this: 
> > > > >
> > > > > 1. The client opens up a big window,
> > > > > 2. the server sends 19 packets in a row
> (pkt
> > #14-
> > > #32 in the trace), but all of them are dropped
> due to
> > some
> > > congestion.
> > > > > 3. The server hits RTO and retransmits
> pkt
> > #14 in
> > > #33
> > > > > 4. The client immediately acks #33
> (=#14),
> > and
> > > the server (seems like to enter F-RTO) expends
> the
> > window
> > > and sends *NEW* pkt #35 & #36.=A0 Timeoute
> is
> > doubled to
> > > 2*RTO; The client immediately sends two Dup-ack
> to #35
> > and
> > > #36.
> > > > > 5. after 2*RTO, pkt #15 is
> retransmitted in
> > #39.
> > > > > 6. The client immediately acks #39
> (=#15) in
> > #40,
> > > and the server continues to expand the window
> and
> > sends two
> > > *NEW* pkt #41 & #42. Now the timeoute is
> doubled
> > to 4
> > > *RTO.
> > > > > 8. After 4*RTO timeout, #16 is
> > retransmitted.
> > > > > 9....
> > > > > 10. The above steps repeats for
> > retransmitting
> > > pkt #16-#32 and each time the timeout is
> doubled.
> > > > > 11. It takes a long long time to
> retransmit
> > all
> > > the lost packets and before that is done, the
> client
> > sends a
> > > RST because of timeout.
> > > > >
> > > > > The above behavior looks like F-RTO is
> in
> > effect.
> > >  And there seems to 
> > > > > be a bug in the TCP's congestion
> control
> > and
> > > retransmission algorithm. 
> > > > > Why doesn't the TCP on server (running
> > 2.6.24)
> > > enter the slow start? 
> > > > > Why should the server take that long
> to
> > recover
> > > from a short period 
> > > > > of packet loss?
> > > > >
> > > > > Has anyone else noticed similar
> problem
> > before?
> > >  If my analysis was 
> > > > > wrong, can anyone gives me some
> pointers to
> > > what's really wrong and 
> > > > > how to fix it?
> > > 
> > > Yes, 2.6.24 is an obsoleted version with known
> wrongs
> > in
> > > FRTO 
> > > implementation. Fixes never when to 2.6.24
> stable
> > series as
> > > it was 
> > > _already_ obsoleted when the problems where
> reported
> > and
> > > found. The 
> > > correct fixes may be found from 2.6.25.7 (.7
> iirc) and
> > are
> > > included from 
> > > 2.6.26 onward too.
> > > 
> > > Just in case you happen to run ubuntu based
> kernel
> > from
> > > that era (of 
> > > course you should be reporting the bug here
> then...),
> > a
> > > word of warning: 
> > > it seemed nearly impossible for them to get a
> simple
> > thing
> > > like that 
> > > fixed, I haven't been looking if they'd
> eventually
> > come to
> > > some sensible 
> > > conclusion in that matter or is it still
> unresolved
> > (or
> > > e.g., closed 
> > > without real resolution).
> 


      

