Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZLKPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZLKPK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLKPK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:10:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbZLKPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:10:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=hWOFdWhLzxcA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=W2nVcup9H6R0bdwU7d4A:9 a=q_DAwfW8SQeNC5PrQPJ5ELgllnkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/4] ftrace: Fix MATCH_END_ONLY filter matching
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Riss <frederic.riss@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091211122721.GH5244@nowhere>
References: <4B2217D0.5000308@cn.fujitsu.com>
	 <87d3b2040912110420w270cff7ew36a7f2389a88fdb9@mail.gmail.com>
	 <20091211122721.GH5244@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 10:10:31 -0500
Message-ID: <1260544231.2146.360.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 13:27 +0100, Frederic Weisbecker wrote:
> On Fri, Dec 11, 2009 at 01:20:04PM +0100, Frederic Riss wrote:
> > 2009/12/11 Li Zefan <lizf@cn.fujitsu.com>:
> > > For '*foo' pattern, we should allow any string ending with
> > > 'foo', but ftrace filter incorrectly disallows strings
> > > like bar_foo_foo:
> > [...]
> > >        case MATCH_END_ONLY:
> > > -               ptr = strstr(str, regex);
> > > -               if (ptr && (ptr[len] == 0))
> > > +               slen = strlen(str);
> > > +               if (slen >= len && memcpy(str + slen - len, regex, len))
> > >                        matched = 1;
> > 
> > Shouldn't that be memcmp() == 0? I don't see how memcpy might serve as
> > a compare operator.
> > 
> > Fred.
> 
> 
> Oh you're right, I reviewed it too quickly. Perhaps the star's
> alignment made it possible for only one Frederic to review it
> the right way...
> 

The stars are still fuzzy to me. How does memcpy work here?

-- Steve


