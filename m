Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYDSAJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYDSAJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYDSAJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:09:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:51182 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYDSAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b/yPfDLTYbwx4uOZqX8RwsRnQIv4mK/4dEDnU+++DQE4wlX3YGu86Ax6SBupkPbM5MDWYc6mFRLkCVrNKaA6yWojIA2jcyT3kQqz6dbCkdmjtIQt0LM+C0kgSCzE2LdoWFwvrAJ01lTDLHIRrri+lSsce2+ufn3q44r5YdsYoQo=
Subject: Re: Alternative implementation of the generic __ffs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: dean gaudet <dean@arctic.org>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com>
	 <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>
	 <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
	 <1207507897.18129.1246358115@webmail.messagingengine.com>
	 <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
	 <1207563950.7880.1246457209@webmail.messagingengine.com>
	 <20080418201809.GA5036@mailshack.com>
	 <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 17:09:22 -0700
Message-Id: <1208563762.10414.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 16:46 -0700, dean gaudet wrote:
> On Fri, 18 Apr 2008, Alexander van Heukelum wrote:
> 
> > On Mon, Apr 07, 2008 at 12:25:50PM +0200, Alexander van Heukelum wrote:
> > > On Sun, 6 Apr 2008 13:22:58 -0700 (PDT), "dean gaudet" <dean@arctic.org> said:
> > > > On Sun, 6 Apr 2008, Alexander van Heukelum wrote:
> > > > > The current generic implementation of ffz is O(lg(n)) already
> > > > 
> > > > it's O(lg(n)) time... the operations all depend on each other.
> > > > 
> > > > the implementation i pointed to is O(lg(n)) code space... and the time 
> > > > depends on how parallel the machine is, they're not dependent on each 
> > > > other.
> > > 
> > > Indeed. The worst dependencies are in the sum of all the partial
> > > results in this implementation. And addition is associative, so
> > > partial results can be written as ((a+b)+(c+d))+(e+f). Assuming
> > > perfect parallel execution this would lead to O(ln(ln(n))). Good.
> > 
> > Hello all,
> > 
> > I've implemented ffs (find first set bit) like it is shown
> > in http://www.hackersdelight.org/ (see revisions, page 21).
> 
> sweet!  thanks for doing this.
> 
> 
> > static ATTR int __ffs32_new(unsigned int value)
> > {
> > 	int x0, x1, x2, x3, x4;
> > 
> > 	value &= -value;
> > 	x0 = (value & 0x55555555) ? 0 : 1;
> > 	x1 = (value & 0x33333333) ? 0 : 2;
> > 	x2 = (value & 0x0f0f0f0f) ? 0 : 4;
> > 	x3 = (value & 0x00ff00ff) ? 0 : 8;
> > 	x4 = (value & 0x0000ffff) ? 0 : 16;

How about:
	u8 x;

	value &= -value;
	x = (value & 0x55555555) ? 0 : 1;
	x |= (value & 0x33333333) ? 0 : 2;
	x |= (value & 0x0f0f0f0f) ? 0 : 4;
	x |= (value & 0x00ff00ff) ? 0 : 8;
	x |= (value & 0x0000ffff) ? 0 : 16;

	return x;

Harvey

