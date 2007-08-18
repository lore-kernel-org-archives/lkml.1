Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXHRILW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXHRILW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 04:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXHRIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 04:10:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:28798 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbXHRIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 04:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hd4pju/F2fCafJTjLpZHnpbUe4q0/PFUC/QTTgu1b1uJat/w31+WjYiqfd1EtrPhxWGJ8Nh+7frBAGsbddRgkPKx9BViSC6Sv/SGmkkb9dRbtaQvwSVRf7Jjyhb9/9bxy2GkzGPE/jcfglloDrP5bqt4/6KXj1aApScTVU+bKlo=
Message-ID: <84144f020708180110i1558dc77p84241615c8ceb6a3@mail.gmail.com>
Date: Sat, 18 Aug 2007 11:10:29 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: kfree(0) - ok?
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Satyam Sharma" <satyam@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1187394022.7007.133.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C233CB.9000602@am.sony.com>
	 <1187132149.2618.2.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
	 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
	 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
	 <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
	 <1187394022.7007.133.camel@chaos>
X-Google-Sender-Auth: dd37703541cd2463
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> If yes, who invented this 1980s reminiscence, where you got valid
> pointers for malloc(0) ?

Well, kmalloc(0) has always been legal and traditionally returned a
pointer to a smallest non-zero sized object. We did try to make
kmalloc(0) illegal for a while but ended up fixing up a bunch of
call-sites for little or no gain. I did propose that kmalloc(0) should
return NULL but Linus and others pointed out that we can do better and
not mix up out-of-memory and zero-sized allocations.
