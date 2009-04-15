Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbZDOJW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbZDOJW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZDOJWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:22:14 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:34690 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752709AbZDOJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:22:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iUG5l/i6aXcVZB80QZiQfZeKZFC+62J2x1DKNmaNFbv4KKN8furcAI9zeRUQfSmLUQKQPFhwJ4lx422AOlKIYeeuof77ygUKBnhNkNQwNUCyyODeu00lbX9Mdzmc1HLxcfHJp06hc3kqci+f1FCj5k9WG5Q+/NkSP2TqZk2csmM=  ;
X-YMail-OSG: HSBaEwEVM1mOfpuiob7rlEArr9NHvY2OVeXvNTWIkOB6rzc_19xSg1Ims08OrtG8Oqmu7nMo0oSlP4nc9IytBChvJ1Q4O2H_SHYN_imlR_2gJySOAn4HpKOUCCt_jdXsZFTnvG57c7sG_5nbAWqFx4n3HnABE.eiYs_rS0TElCpIem8ZkBJAjyse1MN5WLOKM9X64p1BqxXdbn4nUs.9FygSEGiywx8dMgehRRAS23zPJgHkLpysftpp_YzmdVpbevBvjZkgoLjGcof5KBPt0yzGvdV8htso_e2CeI1mokp9gd92trch
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Date: Wed, 15 Apr 2009 19:22:03 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
References: <20090414143252.GE28265@random.random> <20090415165431.AC4C.A69D9226@jp.fujitsu.com> <200904151822.33478.nickpiggin@yahoo.com.au>
In-Reply-To: <200904151822.33478.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151922.04508.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 18:22:32 Nick Piggin wrote:
> On Wednesday 15 April 2009 18:05:54 KOSAKI Motohiro wrote:
> > Hi
> > 
> > > On Wednesday 15 April 2009 00:32:52 Andrea Arcangeli wrote:
> > > > On Wed, Apr 15, 2009 at 12:26:34AM +1000, Nick Piggin wrote:
> > > > > Andrea: I didn't veto that set_bit change of yours as such. I just
> > > > 
> > > > I know you didn't ;)
> > > > 
> > > > > noted there could be more atomic operations. Actually I would
> > > > > welcome more comparison between our two approaches, but they seem
> > > > 
> > > > Agree about the welcome of comparison, it'd be nice to measure it the
> > > > enterprise workloads that showed the gup_fast gain in the first place.
> > > 
> > > I think we should be able to ask IBM to run some tests, provided
> > > they still have machines available to do so. Although I don't want
> > > to waste their time so we need to have something that has got past
> > > initial code review and has a chance of being merged.
> > > 
> > > If we get that far, then I can ask them to run tests definitely.
> > 
> > Oh, it seem very charming idea.
> > Nick, I hope to help your patch's rollup. It makes good comparision, I think.
> > Is there my doable thing?
> 
> Well, I guess review and testing. There are few possibilities for
> reducing the cases where we have to de-cow (or increasing the
> cases where we can WP-on-fork), which I'd like to experiment with,
> but I don't know how much it will help...

Oh, I forgot, it needs to be updated for hugepages as well, I'd say.
