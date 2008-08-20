Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYHTPKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYHTPKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYHTPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:10:45 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36744 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751826AbYHTPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:10:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ozdPCATocHJVQolP9Z1TjW80W7JMiBN7y/GphG2ppHlzGAaNXAzQpzYjedJFAY23htnebRAeKu6jvwh3q7TiEAKQQNsZIPZie5ERTkgFJ/JrRto/41H9uzllHcrlduQAvwey7kPAIDO80UeD6UFIeO6gB4rQ6R1+wWe17UpZ+7Q=  ;
X-YMail-OSG: X7LkZVoVM1nP1RhJXzJOO_6xvHLmxqtApaK9iYDb7PAA3Y5IFQgo1Cdc5Mb_wyLDQEJJ22kHLp_xoSez.D.lLrSe1oKuasosq0zx9TLwTQo3jnYdiPu9YqFB6y7iD3GRJO9nfS4az_iCsaWjZoCYijhL
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Date: Thu, 21 Aug 2008 01:10:36 +1000
User-Agent: KMail/1.9.5
Cc: adobriyan@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
References: <1912217169.25608.228.camel@ymzhang> <20080820143209.GA32156@x200.localdomain> <1219242796.8651.54.camel@twins>
In-Reply-To: <1219242796.8651.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210110.37204.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 00:33, Peter Zijlstra wrote:
> On Wed, 2008-08-20 at 18:32 +0400, adobriyan@gmail.com wrote:
> > On Wed, Aug 20, 2008 at 03:32:17PM +0200, Peter Zijlstra wrote:

> > > +#define avg(x, y) ({				\
> > > +	typeof(x) _avg1 = ((x)+1)/2;		\
> > > +	typeof(x) _avg2 = ((y)+1)/2;		\
> >
> > ITYM, typeof(y)
>
> you thought right, I did mean that :-)
>
> > > +	(void) (&_avg1 == &_avg2);		\
> > > +	_avg1 + _avg2; })

I don't think this implementation of avg should go in kernel.h?

It gives an average of 1 and 1 to be 2, 3 and 3 is 4, 1 and 3 is
3 etc.

Maybe it is reasonable for very high numbers that would overflow
if added first, but it doesn't seem reasonable for a generic
averaging function.
